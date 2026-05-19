import json
import subprocess
import urllib.error
from datetime import datetime
from unittest.mock import Mock

import pytest

import nixpkgs_plugin_update as update
from helpers import (
    GITHUB_REPO_URL,
    GITHUB_TAGS_ATOM_URL,
    BinaryResponse,
    JsonResponse,
    graphql_tags,
    atom_feed,
    git_ls_remote_tags,
)


def assert_git_tags_called_once(git_tags: Mock, repo: update.RepoGitHub) -> None:
    git_tags.assert_called_once_with(
        ["git", "ls-remote", "--tags", "--refs", repo.uri],
        stderr=subprocess.STDOUT,
        timeout=10,
    )


def test_github_execute_graphql_sends_expected_request(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = "token"
    captured: dict[str, object] = {}

    def fake_urlopen(request: urllib.request.Request, timeout: int) -> JsonResponse:
        captured["request"] = request
        captured["timeout"] = timeout
        return JsonResponse({"data": {"ok": True}})

    monkeypatch.setattr(update.urllib.request, "urlopen", fake_urlopen)

    assert repo._execute_graphql("query", {"owner": "owner", "name": "repo"}) == {
        "data": {"ok": True}
    }
    request = captured["request"]
    assert isinstance(request, urllib.request.Request)
    assert request.full_url == "https://api.github.com/graphql"
    assert request.get_header("Authorization") == "token token"
    assert request.get_header("Content-type") == "application/json"
    assert json.loads(request.data or b"{}") == {
        "query": "query",
        "variables": {"owner": "owner", "name": "repo"},
    }
    assert captured["timeout"] == 10


def test_github_get_latest_tag_without_token_uses_fallback(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = ""
    fallback = Mock(return_value="v1.2.3")
    graphql = Mock()
    monkeypatch.setattr(repo, "_get_latest_tag_from_fallbacks", fallback)
    monkeypatch.setattr(repo, "_execute_graphql", graphql)

    assert repo.get_latest_tag() == "v1.2.3"
    fallback.assert_called_once_with()
    graphql.assert_not_called()


def test_github_get_latest_tag_selects_first_recent_stable_release(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = "token"
    graphql = Mock(
        return_value=graphql_tags(
            "v1.2.0-dev",
            "v1.2.0-rc1",
            "nightly",
            "v1.2.0",
            "v1.3.0",
        )
    )
    fallback = Mock()
    monkeypatch.setattr(
        repo,
        "_execute_graphql",
        graphql,
    )
    monkeypatch.setattr(repo, "_get_latest_tag_from_fallbacks", fallback)

    assert repo.get_latest_tag() == "v1.2.0"
    graphql.assert_called_once()
    assert graphql.call_args.args[1] == {"owner": "owner", "name": "repo"}
    fallback.assert_not_called()


def test_github_get_latest_tag_sends_real_graphql_tag_query(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = "token"
    requests: list[tuple[urllib.request.Request, int]] = []

    def fake_urlopen(request: urllib.request.Request, timeout: int) -> JsonResponse:
        requests.append((request, timeout))
        return JsonResponse(graphql_tags("nightly", "v2.1.0"))

    monkeypatch.setattr(update.urllib.request, "urlopen", fake_urlopen)

    assert repo.get_latest_tag() == "v2.1.0"
    request, _timeout = requests[0]
    payload = json.loads(request.data or b"{}")
    assert 'refs(refPrefix: "refs/tags/", first: 20' in payload["query"]
    assert "direction: DESC" in payload["query"]
    assert "TAG_COMMIT_DATE" in payload["query"]
    assert "name" in payload["query"]


def test_github_get_latest_tag_falls_back_on_rate_limit(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = "token"
    calls: list[tuple[str, object]] = []
    graphql = Mock(
        side_effect=lambda query, variables: (
            calls.append(("graphql", variables)) or {"errors": [{"type": "RATE_LIMIT"}]}
        )
    )
    fallback = Mock(side_effect=lambda: calls.append(("fallback", None)) or "v1.0.0")
    monkeypatch.setattr(repo, "_execute_graphql", graphql)
    monkeypatch.setattr(repo, "_get_latest_tag_from_fallbacks", fallback)

    assert repo.get_latest_tag() == "v1.0.0"
    assert calls == [
        ("graphql", {"owner": "owner", "name": "repo"}),
        ("fallback", None),
    ]
    graphql.assert_called_once()
    fallback.assert_called_once_with()


@pytest.mark.parametrize(
    "graphql_response",
    [
        {"data": {"repository": None}},
        {"data": {"repository": {"refs": None}}},
        {"data": {"repository": {"refs": {}}}},
        {"data": {"repository": {"refs": {"nodes": []}}}},
        {"data": {"repository": {"refs": {"nodes": [{"missing": "name"}]}}}},
        {"errors": [{"message": "backend temporarily unavailable"}]},
    ],
)
def test_github_get_latest_tag_falls_back_on_realistic_bad_graphql_payloads(
    monkeypatch: pytest.MonkeyPatch, graphql_response: dict[str, object]
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = "token"
    calls: list[tuple[str, object]] = []
    graphql = Mock(
        side_effect=lambda query, variables: (
            calls.append(("graphql", variables)) or graphql_response
        )
    )
    fallback = Mock(side_effect=lambda: calls.append(("fallback", None)) or "v1.2.3")
    monkeypatch.setattr(repo, "_execute_graphql", graphql)
    monkeypatch.setattr(repo, "_get_latest_tag_from_fallbacks", fallback)

    assert repo.get_latest_tag() == "v1.2.3"
    assert calls == [
        ("graphql", {"owner": "owner", "name": "repo"}),
        ("fallback", None),
    ]
    graphql.assert_called_once()
    fallback.assert_called_once_with()


@pytest.mark.parametrize(
    (
        "graphql_result",
        "atom_result",
        "expected_tag",
        "expect_git_fallback",
    ),
    [
        pytest.param(
            graphql_tags(),
            atom_feed("nightly", "v2.0.0"),
            "v2.0.0",
            False,
            id="empty-graphql-uses-atom",
        ),
        pytest.param(
            {"errors": [{"message": "backend unavailable"}]},
            b"<feed",
            "v2.0.0",
            True,
            id="bad-graphql-and-atom-use-git",
        ),
        pytest.param(
            urllib.error.URLError("offline"),
            atom_feed("v1.2.3"),
            "v1.2.3",
            False,
            id="graphql-transport-error-uses-atom",
        ),
    ],
)
def test_github_get_latest_tag_fallback_call_order(
    monkeypatch: pytest.MonkeyPatch,
    graphql_result: dict[str, object] | urllib.error.URLError,
    atom_result: bytes,
    expected_tag: str,
    expect_git_fallback: bool,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = "token"
    calls: list[str] = []
    git_tags = Mock(return_value=git_ls_remote_tags("v1.9.0", "v2.0.0"))

    def fake_urlopen(
        request: urllib.request.Request, timeout: int
    ) -> JsonResponse | BinaryResponse:
        calls.append(request.full_url)
        assert timeout == 10
        if request.full_url == "https://api.github.com/graphql":
            if isinstance(graphql_result, urllib.error.URLError):
                raise graphql_result
            return JsonResponse(graphql_result)
        if request.full_url == GITHUB_TAGS_ATOM_URL:
            return BinaryResponse(atom_result)
        raise AssertionError(f"unexpected request: {request.full_url}")

    monkeypatch.setattr(update.urllib.request, "urlopen", fake_urlopen)
    monkeypatch.setattr(update.subprocess, "check_output", git_tags)

    assert repo.get_latest_tag() == expected_tag
    assert calls == [
        "https://api.github.com/graphql",
        GITHUB_TAGS_ATOM_URL,
    ]
    if expect_git_fallback:
        assert_git_tags_called_once(git_tags, repo)
    else:
        git_tags.assert_not_called()


def test_github_get_latest_tag_raises_on_bad_auth(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = "token"
    monkeypatch.setattr(
        repo,
        "_execute_graphql",
        Mock(side_effect=urllib.error.HTTPError("", 403, "", {}, None)),
    )

    with pytest.raises(RuntimeError, match="refresh GITHUB_TOKEN"):
        repo.get_latest_tag()


def test_github_recent_tags_parses_atom_feed(monkeypatch: pytest.MonkeyPatch) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    urlopen = Mock(
        return_value=BinaryResponse(atom_feed("nightly", "v1.2.3", "release/1.2.3"))
    )
    monkeypatch.setattr(update.urllib.request, "urlopen", urlopen)

    assert repo._get_recent_tags_from_atom() == ["nightly", "v1.2.3", "release/1.2.3"]
    request = urlopen.call_args.args[0]
    assert isinstance(request, urllib.request.Request)
    assert request.full_url == GITHUB_TAGS_ATOM_URL
    assert urlopen.call_args.kwargs == {"timeout": 10}


def test_github_recent_tags_ignores_incomplete_atom_entries(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    xml = b"""<?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <entry>
        <title>missing link</title>
      </entry>
      <entry>
        <link />
      </entry>
      <entry>
        <link href="https://github.com/owner/repo/releases/tag/v1.2.3" />
      </entry>
    </feed>
    """
    monkeypatch.setattr(
        update.urllib.request,
        "urlopen",
        Mock(return_value=BinaryResponse(xml)),
    )

    assert repo._get_recent_tags_from_atom() == ["v1.2.3"]


def test_github_fallback_tag_feed_selects_first_release(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    atom = Mock(return_value=["v1.2.0-rc1", "nightly", "v1.2.0", "v1.3.0"])
    git_tags = Mock()
    monkeypatch.setattr(repo, "_get_recent_tags_from_atom", atom)
    monkeypatch.setattr(update.subprocess, "check_output", git_tags)

    assert repo._get_latest_tag_from_fallbacks() == "v1.2.0"
    atom.assert_called_once_with()
    git_tags.assert_not_called()


def test_github_fallback_tag_feed_retries_atom_before_git(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    urlopen = Mock(side_effect=urllib.error.URLError("offline"))
    sleep = Mock()
    git_tags = Mock(return_value=git_ls_remote_tags("v1.9.0", "v2.0.0"))
    monkeypatch.setattr(update.urllib.request, "urlopen", urlopen)
    monkeypatch.setattr(update.time, "sleep", sleep)
    monkeypatch.setattr(update.subprocess, "check_output", git_tags)

    assert repo._get_latest_tag_from_fallbacks() == "v2.0.0"
    assert urlopen.call_count == 4
    assert [call.args[0].full_url for call in urlopen.call_args_list] == [
        GITHUB_TAGS_ATOM_URL,
        GITHUB_TAGS_ATOM_URL,
        GITHUB_TAGS_ATOM_URL,
        GITHUB_TAGS_ATOM_URL,
    ]
    assert [call.kwargs for call in urlopen.call_args_list] == [
        {"timeout": 10},
        {"timeout": 10},
        {"timeout": 10},
        {"timeout": 10},
    ]
    assert [call.args[0] for call in sleep.call_args_list] == [3, 6, 12]
    assert_git_tags_called_once(git_tags, repo)


def test_github_fallback_tag_feed_uses_git_tags_when_atom_is_malformed(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    atom = Mock(side_effect=update.ET.ParseError("bad xml"))
    git_tags = Mock(
        return_value=git_ls_remote_tags(
            "v1.9.9",
            "nightly",
            "v1.10.0-rc1",
            "sign-test",
            "v1.10.0",
            "v1.2.0",
        )
    )
    monkeypatch.setattr(repo, "_get_recent_tags_from_atom", atom)
    monkeypatch.setattr(update.subprocess, "check_output", git_tags)

    assert repo._get_latest_tag_from_fallbacks() == "v1.10.0"
    atom.assert_called_once_with()
    assert_git_tags_called_once(git_tags, repo)


def test_github_fallback_tag_feed_returns_none_when_all_sources_fail(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    atom = Mock(side_effect=urllib.error.URLError("offline"))
    git_tags = Mock(side_effect=subprocess.CalledProcessError(1, ["git", "ls-remote"]))
    monkeypatch.setattr(repo, "_get_recent_tags_from_atom", atom)
    monkeypatch.setattr(update.subprocess, "check_output", git_tags)

    assert repo._get_latest_tag_from_fallbacks() is None
    atom.assert_called_once_with()
    assert_git_tags_called_once(git_tags, repo)


def test_github_latest_commit_parses_atom_feed(monkeypatch: pytest.MonkeyPatch) -> None:
    repo = update.RepoGitHub("owner", "repo", "main")
    xml = b"""<?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <entry>
        <updated>2024-02-03T04:05:06Z</updated>
        <link href="https://github.com/owner/repo/commit/abcdef123456" />
      </entry>
    </feed>
    """
    urlopen = Mock(return_value=BinaryResponse(xml))
    monkeypatch.setattr(update.urllib.request, "urlopen", urlopen)

    assert repo.latest_commit() == (
        "abcdef123456",
        datetime(2024, 2, 3, 4, 5, 6),
    )
    request = urlopen.call_args.args[0]
    assert isinstance(request, urllib.request.Request)
    assert request.full_url == f"{GITHUB_REPO_URL}/commits/main.atom"
    assert urlopen.call_args.kwargs == {"timeout": 10}


def test_github_latest_commit_records_redirected_repository(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("old-owner", "old-repo", "main")
    xml = b"""<?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <entry>
        <updated>2024-02-03T04:05:06Z</updated>
        <link href="https://github.com/new-owner/new-repo/commit/abcdef123456" />
      </entry>
    </feed>
    """
    urlopen = Mock(
        return_value=BinaryResponse(
            xml,
            url="https://github.com/new-owner/new-repo/commits/main.atom",
        )
    )
    monkeypatch.setattr(update.urllib.request, "urlopen", urlopen)

    assert repo.latest_commit() == (
        "abcdef123456",
        datetime(2024, 2, 3, 4, 5, 6),
    )
    assert urlopen.call_count == 1
    assert isinstance(repo.redirect, update.RepoGitHub)
    assert repo.redirect.owner == "new-owner"
    assert repo.redirect.repo == "new-repo"


def test_github_resolve_ref_uses_latest_commit_for_branch_without_redirect_lookup(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "main")
    latest_commit = Mock(return_value=("abcdef123456", datetime(2024, 2, 3, 4, 5, 6)))
    check_ref_redirect = Mock()
    base_resolve_ref = Mock(side_effect=AssertionError("unexpected base resolve"))
    monkeypatch.setattr(repo, "latest_commit", latest_commit)
    monkeypatch.setattr(repo, "_check_ref_redirect", check_ref_redirect)
    monkeypatch.setattr(update.Repo, "resolve_ref", base_resolve_ref)

    assert repo.resolve_ref("main") == ("abcdef123456", datetime(2024, 2, 3, 4, 5, 6))
    latest_commit.assert_called_once_with()
    check_ref_redirect.assert_not_called()
    base_resolve_ref.assert_not_called()


def test_github_check_ref_redirect_requests_encoded_ref_once(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "main")
    urlopen = Mock(
        return_value=BinaryResponse(
            b"",
            url=f"{GITHUB_REPO_URL}/tree/refs%2Ftags%2Fv1.2.3",
        )
    )
    monkeypatch.setattr(update.urllib.request, "urlopen", urlopen)

    repo._check_ref_redirect("refs/tags/v1.2.3")

    request = urlopen.call_args.args[0]
    assert isinstance(request, urllib.request.Request)
    assert request.full_url == f"{GITHUB_REPO_URL}/tree/refs%2Ftags%2Fv1.2.3"
    assert urlopen.call_args.kwargs == {"timeout": 10}


def test_github_has_submodules_retries_transient_url_errors(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "main")
    urlopen = Mock(
        side_effect=[
            urllib.error.URLError("offline"),
            urllib.error.URLError("offline"),
            urllib.error.URLError("offline"),
            BinaryResponse(b""),
        ]
    )
    sleep = Mock()
    monkeypatch.setattr(update.urllib.request, "urlopen", urlopen)
    monkeypatch.setattr(update.time, "sleep", sleep)

    assert repo.has_submodules() is True
    assert urlopen.call_count == 4
    assert [call.args[0] for call in sleep.call_args_list] == [3, 6, 12]


def test_github_has_submodules_does_not_retry_404(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "main")
    urlopen = Mock(side_effect=urllib.error.HTTPError("", 404, "", {}, None))
    monkeypatch.setattr(update.urllib.request, "urlopen", urlopen)
    monkeypatch.setattr(update.time, "sleep", Mock())

    assert repo.has_submodules() is False
    urlopen.assert_called_once()


@pytest.mark.parametrize(
    ("provided_flag", "discovered", "expected", "should_discover"),
    [
        pytest.param(None, False, "sha256-github", True, id="discover-no-submodules"),
        pytest.param(None, True, "sha256-git", True, id="discover-submodules"),
        pytest.param(False, True, "sha256-github", False, id="explicit-no-submodules"),
        pytest.param(True, False, "sha256-git", False, id="explicit-submodules"),
    ],
)
def test_github_prefetch_routes_by_submodule_status(
    monkeypatch: pytest.MonkeyPatch,
    provided_flag: bool | None,
    discovered: bool,
    expected: str,
    should_discover: bool,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    prefetch_github = Mock(return_value="sha256-github")
    base_prefetch = Mock(return_value="sha256-git")
    has_submodules_lookup = Mock(return_value=discovered)
    monkeypatch.setattr(repo, "has_submodules", has_submodules_lookup)
    monkeypatch.setattr(repo, "prefetch_github", prefetch_github)
    monkeypatch.setattr(update.Repo, "prefetch", base_prefetch)

    assert repo.prefetch("abcdef", has_submodules=provided_flag) == expected
    if should_discover:
        has_submodules_lookup.assert_called_once_with()
    else:
        has_submodules_lookup.assert_not_called()

    if expected == "sha256-git":
        base_prefetch.assert_called_once_with("abcdef")
        prefetch_github.assert_not_called()
    else:
        prefetch_github.assert_called_once_with("abcdef")
        base_prefetch.assert_not_called()


@pytest.mark.parametrize(
    ("urlopen_result", "fallback_license", "expected"),
    [
        pytest.param(
            JsonResponse({"license": {"spdx_id": "MIT"}}),
            None,
            "MIT",
            id="spdx",
        ),
        pytest.param(
            JsonResponse({"license": {"spdx_id": "NOASSERTION"}}),
            None,
            None,
            id="noassertion",
        ),
        pytest.param(
            urllib.error.HTTPError("", 404, "", {}, None),
            "MIT",
            None,
            id="missing-license",
        ),
        pytest.param(
            urllib.error.URLError("offline"),
            "MIT",
            "MIT",
            id="transient-error",
        ),
    ],
)
def test_github_license_returns_expected_spdx_or_fallback(
    monkeypatch: pytest.MonkeyPatch,
    urlopen_result: JsonResponse | urllib.error.HTTPError | urllib.error.URLError,
    fallback_license: str | None,
    expected: str | None,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = "token"
    urlopen = Mock(
        side_effect=urlopen_result
        if isinstance(urlopen_result, urllib.error.URLError)
        else None,
        return_value=urlopen_result
        if not isinstance(urlopen_result, urllib.error.URLError)
        else None,
    )
    monkeypatch.setattr(update.urllib.request, "urlopen", urlopen)

    assert repo.get_license_spdx_id(fallback_license) == expected
    urlopen.assert_called_once()
    request = urlopen.call_args.args[0]
    assert isinstance(request, urllib.request.Request)
    assert request.full_url == "https://api.github.com/repos/owner/repo/license"
    assert request.get_header("Authorization") == "token token"
    assert urlopen.call_args.kwargs == {"timeout": 10}
