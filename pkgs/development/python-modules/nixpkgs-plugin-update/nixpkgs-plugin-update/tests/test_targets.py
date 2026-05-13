import json
import urllib.error
from datetime import datetime, timezone
from pathlib import Path
from unittest.mock import Mock

import pytest

import nixpkgs_plugin_update as update
from helpers import (
    BinaryResponse,
    BoundaryRecorder,
    FakeCache,
    FakeRepo,
    GITHUB_LICENSE_URL,
    GITHUB_REPO_URL,
    GITHUB_TAGS_ATOM_URL,
    JsonResponse,
    atom_feed,
    plugin,
    plugin_desc,
)


RELEASE_DATE = datetime(2024, 1, 15, tzinfo=timezone.utc)
HEAD_DATE = datetime(2024, 2, 1, tzinfo=timezone.utc)
BOUNDARY_DATE = datetime(2024, 5, 6, tzinfo=timezone.utc)
GITHUB_REPO_GIT_URL = f"{GITHUB_REPO_URL}/"
GITHUB_SUBMODULES_URL = f"{GITHUB_REPO_URL}/blob/HEAD/.gitmodules"
GITHUB_TAG_TREE_URL = f"{GITHUB_REPO_URL}/tree/refs%2Ftags%2Fv1.2.3"


def tag_ref(tag: str) -> str:
    return f"{update.GIT_TAGS_PREFIX}{tag}"


@pytest.mark.parametrize(
    (
        "repo",
        "current",
        "latest_tag",
        "expected",
    ),
    [
        (
            FakeRepo(refs={tag_ref("v1.1.0"): ("commit-release", RELEASE_DATE)}),
            None,
            "v1.1.0",
            ("commit-release", RELEASE_DATE, "1.1.0", "v1.1.0"),
        ),
        (
            FakeRepo(
                latest_commit=("commit-head", HEAD_DATE),
                refs={tag_ref("v1.1.0"): ("commit-release", RELEASE_DATE)},
            ),
            plugin(
                version="1.0.0-unstable-2024-01-20",
                date=datetime(2024, 1, 20, tzinfo=timezone.utc),
            ),
            "v1.1.0",
            ("commit-head", HEAD_DATE, "1.1.0-unstable-2024-02-01", None),
        ),
        (
            FakeRepo(
                latest_commit=("commit-head", HEAD_DATE),
                refs={tag_ref("v1.3.1"): ("commit-release", RELEASE_DATE)},
            ),
            plugin(
                version="1.4-rc1-unstable-2024-01-20",
                date=datetime(2024, 1, 20, tzinfo=timezone.utc),
                last_tag="1.4-rc1",
            ),
            "v1.3.1",
            ("commit-head", HEAD_DATE, "1.4-rc1-unstable-2024-02-01", None),
        ),
        (
            FakeRepo(refs={tag_ref("v1.1.0"): ("commit-release", RELEASE_DATE)}),
            plugin(version="1.0.0-unstable-2024-01-15", date=RELEASE_DATE),
            "v1.1.0",
            ("commit-release", RELEASE_DATE, "1.1.0", "v1.1.0"),
        ),
        (
            FakeRepo(latest_commit=("commit-head", HEAD_DATE)),
            None,
            "prerelease",
            ("commit-head", HEAD_DATE, "0-unstable-2024-02-01", None),
        ),
    ],
)
def test_auto_branch_selects_expected_target(
    repo: FakeRepo,
    current: update.Plugin | None,
    latest_tag: str,
    expected: tuple[str, datetime, str, str | None],
) -> None:
    assert update.select_plugin_target(plugin_desc(repo), current, latest_tag) == expected


def test_explicit_branch_bypasses_release_heuristic() -> None:
    branch_date = datetime(2024, 3, 1, tzinfo=timezone.utc)
    repo = FakeRepo(refs={"main": ("commit-main", branch_date)})

    assert update.select_plugin_target(plugin_desc(repo, "main"), None, "v1.1.0") == (
        "commit-main",
        branch_date,
        "1.1.0-unstable-2024-03-01",
        None,
    )


def test_get_current_plugins_handles_realistic_mixed_eval_output(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setattr(
        update,
        "run_nix_expr",
        Mock(
            return_value={
                "friendly-name": {
                    "pname": "actual.nvim",
                    "version": "2.4.0",
                    "homePage": "https://github.com/owner/actual.nvim",
                    "checksum": {
                        "rev": "release-commit",
                        "submodules": False,
                        "sha256": "sha256-release",
                        "tag": "v2.4.0",
                    },
                    "license": "Apache-2.0",
                },
                "unstable-plugin": {
                    "pname": "unstable-plugin",
                    "version": "1.9.0-unstable-2024-05-06",
                    "homePage": "https://github.com/owner/unstable-plugin",
                    "checksum": {
                        "rev": "unstable-commit",
                        "submodules": True,
                        "sha256": "sha256-unstable",
                    },
                },
            }
        ),
    )
    editor = update.Editor("vim", tmp_path, "unused")

    plugins = editor.get_current_plugins(update.FetchConfig(1, "token"), str(tmp_path))

    tagged_desc, tagged = plugins[0]
    unstable_desc, unstable = plugins[1]
    assert tagged_desc.name == "friendly-name"
    assert tagged_desc.branch == update.AUTO_BRANCH
    assert tagged_desc.repo.name == "actual.nvim"
    assert tagged_desc.repo.token == "token"
    assert tagged.name == "actual.nvim"
    assert tagged.tag == "v2.4.0"
    assert tagged.date is None
    assert tagged.last_tag is None
    assert tagged.license == "Apache-2.0"
    assert unstable_desc.name == "unstable-plugin"
    assert unstable_desc.branch == update.AUTO_BRANCH
    assert unstable.tag is None
    assert unstable.date == datetime(2024, 5, 6)
    assert unstable.last_tag == "1.9.0"
    assert unstable.has_submodules is True
    assert unstable.license is None


def test_get_current_plugins_rejects_unparseable_unstable_version(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setattr(
        update,
        "run_nix_expr",
        Mock(
            return_value={
                "bad-plugin": {
                    "pname": "bad-plugin",
                    "version": "unstable",
                    "homePage": "https://github.com/owner/bad-plugin",
                    "checksum": {
                        "rev": "abcdef",
                        "submodules": False,
                        "sha256": "sha256-example",
                    },
                },
            }
        ),
    )
    editor = update.Editor("vim", tmp_path, "unused")

    with pytest.raises(ValueError, match="Cannot parse unstable version"):
        editor.get_current_plugins(update.FetchConfig(1, ""), str(tmp_path))


def test_cache_keys_include_repo_and_selected_ref() -> None:
    current = plugin(tag="v1.2.3")
    assert (
        update.plugin_cache_key("https://example.com/repo", current)
        == f"https://example.com/repo@{update.GIT_TAGS_PREFIX}v1.2.3"
    )
    assert (
        update.target_cache_key("https://example.com/repo", "abcdef", None)
        == "https://example.com/repo@abcdef"
    )


def test_cache_hit_replaces_metadata_without_mutating_cached_plugin(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("XDG_CACHE_HOME", str(tmp_path))
    release_date = RELEASE_DATE
    repo = FakeRepo(
        latest_tag="v1.1.0",
        refs={tag_ref("v1.1.0"): ("commit-release", release_date)},
    )
    desc = plugin_desc(repo)
    cached = plugin(
        name="old-name",
        commit="commit-release",
        version="old",
        tag="v1.1.0",
        license="MIT",
    )
    cache = update.Cache([(desc, cached)], "nixpkgs-plugin-update-test-cache.json")

    fetched, _redirect = update.prefetch_plugin(desc, cache=cache)

    assert fetched.name == "repo"
    assert fetched.commit == "commit-release"
    assert fetched.version == "1.1.0"
    assert fetched.tag == "v1.1.0"
    assert fetched.license == "MIT"
    assert cached.name == "old-name"
    assert cached.version == "old"
    assert repo.prefetch_calls == []


def test_cache_hit_fetches_license_once_when_cache_and_current_plugin_lack_it() -> None:
    release_date = RELEASE_DATE
    repo = FakeRepo(
        latest_tag="v1.1.0",
        refs={tag_ref("v1.1.0"): ("commit-release", release_date)},
        license_spdx_id="Apache-2.0",
    )
    desc = plugin_desc(repo)
    cached = plugin(commit="commit-release", version="old", tag="v1.1.0", license=None)
    cache = FakeCache(
        {update.target_cache_key(repo.uri, "commit-release", "v1.1.0"): cached}
    )

    fetched, _redirect = update.prefetch_plugin(desc, cache=cache)

    assert fetched.license == "Apache-2.0"
    assert repo.license_calls == 1
    assert repo.prefetch_calls == []


def test_prefetch_plugin_reuses_current_license_before_fetching_license() -> None:
    head_date = HEAD_DATE
    repo = FakeRepo(
        latest_commit=("commit-head", head_date),
    )
    current = plugin(license="Apache-2.0")

    fetched, _redirect = update.prefetch_plugin(
        plugin_desc(repo), current_plugin=current
    )

    assert fetched.license == "Apache-2.0"
    assert repo.prefetch_call_details == [("commit-head", False)]
    assert repo.license_calls == 0


def test_prefetch_plugin_cache_miss_fetches_selected_tag_ref() -> None:
    release_date = RELEASE_DATE
    repo = FakeRepo(
        latest_tag="v1.1.0",
        refs={tag_ref("v1.1.0"): ("commit-release", release_date)},
        license_spdx_id="Apache-2.0",
        has_submodules=True,
    )
    cache = FakeCache()

    fetched, _redirect = update.prefetch_plugin(plugin_desc(repo), cache=cache)

    assert fetched.commit == "commit-release"
    assert fetched.tag == "v1.1.0"
    assert fetched.has_submodules is True
    assert fetched.sha256 == "sha256-prefetched"
    assert fetched.license == "Apache-2.0"
    assert repo.prefetch_call_details == [(tag_ref("v1.1.0"), True)]
    assert repo.license_calls == 1


def test_prefetch_stores_fetched_plugin_in_cache() -> None:
    head_date = HEAD_DATE
    repo = FakeRepo(latest_commit=("commit-head", head_date), license_spdx_id="MIT")
    desc = plugin_desc(repo)
    cache = FakeCache()

    result_desc, result, redirect = update.prefetch(desc, cache)

    assert result_desc is desc
    assert isinstance(result, update.Plugin)
    assert redirect is None
    assert result.license == "MIT"
    assert cache[update.target_cache_key(repo.uri, "commit-head", None)] is result
    assert repo.prefetch_call_details == [("commit-head", False)]
    assert repo.license_calls == 1


def test_prefetch_uses_current_plugin_metadata_and_real_cache(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("XDG_CACHE_HOME", str(tmp_path))
    head_date = HEAD_DATE
    repo = FakeRepo(latest_commit=("commit-head", head_date), name="foo.nvim")
    desc = plugin_desc(repo)
    cache = update.Cache([], "nixpkgs-plugin-update-test-cache.json")
    current_plugins = {
        "foo-nvim": plugin(name="foo.nvim", license="Apache-2.0"),
    }

    result_desc, result, redirect = update.prefetch(desc, cache, current_plugins)

    assert result_desc is desc
    assert isinstance(result, update.Plugin)
    assert redirect is None
    assert result.name == "foo.nvim"
    assert result.version == "0-unstable-2024-02-01"
    assert result.license == "Apache-2.0"
    assert cache[update.target_cache_key(repo.uri, "commit-head", None)] is result
    assert repo.prefetch_call_details == [("commit-head", False)]
    assert repo.license_calls == 0


def test_get_update_counts_prefetches_and_stores_cache_once(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    release_date = RELEASE_DATE
    head_date = HEAD_DATE
    cached_repo = FakeRepo(
        name="cached",
        uri="https://example.com/owner/cached",
        latest_tag="v1.1.0",
        refs={f"{update.GIT_TAGS_PREFIX}v1.1.0": ("cached-release", release_date)},
    )
    missing_repo = FakeRepo(
        name="missing",
        uri="https://example.com/owner/missing",
        latest_commit=("missing-head", head_date),
        license_spdx_id="Apache-2.0",
    )
    kept_repo = FakeRepo(
        name="kept",
        uri="https://example.com/owner/kept",
        latest_commit=("kept-head", head_date),
    )
    cached_desc = plugin_desc(cached_repo)
    missing_desc = plugin_desc(missing_repo)
    kept_desc = plugin_desc(kept_repo)
    current_plugins = [
        (cached_desc, plugin(name="cached", commit="cached-current", version="1.0.0")),
        (
            missing_desc,
            plugin(name="missing", commit="missing-current", version="1.0.0"),
        ),
        (kept_desc, plugin(name="kept", commit="kept-current", version="1.0.0")),
    ]

    class CountingCache(FakeCache):
        def __init__(self) -> None:
            super().__init__(
                {
                    update.target_cache_key(
                        cached_repo.uri,
                        "cached-release",
                        "v1.1.0",
                    ): plugin(
                        name="cached",
                        commit="cached-release",
                        version="1.1.0",
                        tag="v1.1.0",
                        license="MIT",
                    ),
                }
            )
            self.store_calls = 0

        def store(self) -> None:
            self.store_calls += 1

    class CountingPool:
        def __init__(self, processes: int) -> None:
            self.processes = processes
            pool_processes.append(processes)

        def map(self, func, items):  # type: ignore[no-untyped-def]
            mapped_items.extend(items)
            return [func(item) for item in items]

    cache = CountingCache()
    generated_plugins: list[tuple[update.PluginDesc, update.Plugin]] = []
    pool_processes: list[int] = []
    mapped_items: list[update.PluginDesc] = []
    editor = update.Editor("vim", tmp_path, "unused")
    editor.nixpkgs = str(tmp_path)

    monkeypatch.setattr(update, "Cache", Mock(return_value=cache))
    monkeypatch.setattr(update, "Pool", CountingPool)
    monkeypatch.setattr(
        editor,
        "get_current_plugins",
        Mock(return_value=current_plugins),
    )
    monkeypatch.setattr(
        editor,
        "load_plugin_spec",
        Mock(return_value=[cached_desc, missing_desc, kept_desc]),
    )
    monkeypatch.setattr(
        editor,
        "generate_nix",
        Mock(side_effect=lambda plugins, _outfile: generated_plugins.extend(plugins)),
    )

    run_update = editor.get_update(
        "plugin-names",
        "generated.nix",
        update.FetchConfig(2, ""),
        ["cached", "missing"],
    )
    redirects, updated_plugins = run_update()

    assert redirects == {}
    assert updated_plugins == [
        ("cached", "1.0.0", "1.1.0"),
        ("missing", "1.0.0", "0-unstable-2024-02-01"),
    ]
    assert pool_processes == [2]
    assert mapped_items == [cached_desc, missing_desc]
    assert cache.store_calls == 1
    assert [plugin.name for _desc, plugin in generated_plugins] == [
        "cached",
        "kept",
        "missing",
    ]
    assert missing_repo.prefetch_call_details == [("missing-head", False)]
    assert kept_repo.prefetch_calls == []


def test_prefetch_returns_exception_when_selected_tag_cannot_be_resolved() -> None:
    repo = FakeRepo(latest_tag="v9.9.9")
    desc = plugin_desc(repo)

    result_desc, result, redirect = update.prefetch(desc, FakeCache())

    assert result_desc is desc
    assert isinstance(result, AssertionError)
    assert "refs/tags/v9.9.9" in str(result)
    assert redirect is None


def test_cache_store_load_round_trips_plugins(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("XDG_CACHE_HOME", str(tmp_path))
    cache_file_name = "nixpkgs-plugin-update-test-cache.json"
    current = plugin(
        name="example-plugin",
        commit="abcdef",
        has_submodules=True,
        sha256="sha256-example",
        version="1.2.3",
        last_tag=None,
        tag="v1.2.3",
        license="MIT",
    )
    desc = plugin_desc(FakeRepo(uri="https://example.com/owner/example-plugin"))

    cache = update.Cache([(desc, current)], cache_file_name)
    cache.store()
    loaded_cache = update.Cache([], cache_file_name)

    loaded = loaded_cache["https://example.com/owner/example-plugin@refs/tags/v1.2.3"]
    assert loaded == plugin(
        name="example-plugin",
        commit="abcdef",
        has_submodules=True,
        sha256="sha256-example",
        version="1.2.3",
        date=None,
        last_tag=None,
        tag="v1.2.3",
        license="MIT",
    )


def test_cache_load_reads_realistic_tag_and_commit_entries(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("XDG_CACHE_HOME", str(tmp_path))
    cache_file_name = "nixpkgs-plugin-update-test-cache.json"
    cache_file = tmp_path / cache_file_name
    cache_file.write_text(
        json.dumps(
            {
                "https://github.com/owner/release@refs/tags/v2.4.0": {
                    "name": "release",
                    "commit": "release-commit",
                    "has_submodules": False,
                    "sha256": "sha256-release",
                    "version": "2.4.0",
                    "last_tag": None,
                    "tag": "v2.4.0",
                    "license": "Apache-2.0",
                },
                "https://github.com/owner/nightly@commit-head": {
                    "name": "nightly",
                    "commit": "commit-head",
                    "has_submodules": True,
                    "sha256": "sha256-nightly",
                    "version": "1.9.0-unstable-2024-05-06",
                    "last_tag": "v1.9.0",
                    "tag": None,
                    "license": None,
                },
            }
        )
    )

    cache = update.Cache([], cache_file_name)

    release = cache["https://github.com/owner/release@refs/tags/v2.4.0"]
    nightly = cache["https://github.com/owner/nightly@commit-head"]
    assert release == plugin(
        name="release",
        commit="release-commit",
        has_submodules=False,
        sha256="sha256-release",
        version="2.4.0",
        date=None,
        last_tag=None,
        tag="v2.4.0",
        license="Apache-2.0",
    )
    assert nightly == plugin(
        name="nightly",
        commit="commit-head",
        has_submodules=True,
        sha256="sha256-nightly",
        version="1.9.0-unstable-2024-05-06",
        date=None,
        last_tag="v1.9.0",
        tag=None,
        license=None,
    )


@pytest.mark.parametrize(
    (
        "has_submodules",
        "license_spdx_id",
        "expected_sha256",
        "expected_prefetch_cmd",
    ),
    [
        (
            False,
            "MIT",
            "sha256-github",
            (
                "nix-prefetch-github",
                "owner",
                "repo",
                "--rev",
                tag_ref("v1.2.3"),
                "--json",
            ),
        ),
        (
            True,
            "Apache-2.0",
            "sha256-git",
            (
                "nix-prefetch-git",
                "--quiet",
                "--fetch-submodules",
                GITHUB_REPO_GIT_URL,
                tag_ref("v1.2.3"),
            ),
        ),
    ],
)
def test_prefetch_plugin_real_github_cache_miss_counts_boundary_calls(
    monkeypatch: pytest.MonkeyPatch,
    has_submodules: bool,
    license_spdx_id: str,
    expected_sha256: str,
    expected_prefetch_cmd: tuple[str, ...],
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    repo.token = ""
    recorder = BoundaryRecorder()

    def fake_urlopen(request, timeout: int):  # type: ignore[no-untyped-def]
        recorder.record_urlopen(request, timeout)
        assert timeout == 10
        if request.full_url == GITHUB_TAGS_ATOM_URL:
            return BinaryResponse(atom_feed("v1.2.3"), request.full_url)
        if request.full_url == GITHUB_TAG_TREE_URL:
            return BinaryResponse(url=request.full_url)
        if request.full_url == GITHUB_SUBMODULES_URL:
            if not has_submodules:
                raise urllib.error.HTTPError(request.full_url, 404, "", {}, None)
            return BinaryResponse(url=request.full_url)
        if request.full_url == GITHUB_LICENSE_URL:
            return JsonResponse({"license": {"spdx_id": license_spdx_id}})
        raise AssertionError(f"unexpected request: {request.full_url}")

    def fake_check_output(cmd, **kwargs):  # type: ignore[no-untyped-def]
        recorder.record_check_output(cmd, kwargs)
        if tuple(cmd) == (
            "nix-prefetch-git",
            "--quiet",
            GITHUB_REPO_GIT_URL,
            tag_ref("v1.2.3"),
        ):
            assert kwargs == {}
            return json.dumps(
                {
                    "rev": "release-commit",
                    "date": "2024-05-06T00:00:00+0000",
                    "sha256": "sha256-resolve-only",
                }
            ).encode()
        if tuple(cmd) == expected_prefetch_cmd:
            assert kwargs == {}
            if has_submodules:
                return json.dumps(
                    {
                        "rev": "release-commit",
                        "date": "2024-05-06T00:00:00+0000",
                        "sha256": expected_sha256,
                    }
                ).encode()
            return json.dumps({"hash": expected_sha256}).encode()
        raise AssertionError(f"unexpected subprocess call: {cmd!r}")

    monkeypatch.setattr(update.urllib.request, "urlopen", fake_urlopen)
    monkeypatch.setattr(update.subprocess, "check_output", fake_check_output)

    fetched, redirect = update.prefetch_plugin(
        update.PluginDesc(repo, update.AUTO_BRANCH, None),
        cache=FakeCache(),
    )

    assert redirect is None
    assert fetched == plugin(
        name="repo",
        commit="release-commit",
        has_submodules=has_submodules,
        sha256=expected_sha256,
        version="1.2.3",
        date=BOUNDARY_DATE,
        last_tag="v1.2.3",
        tag="v1.2.3",
        license=license_spdx_id,
    )
    urlopen_calls = [call for call in recorder.calls if call[0] == "urlopen"]
    check_output_calls = [call for call in recorder.calls if call[0] == "check_output"]
    resolve_cmd = (
        "nix-prefetch-git",
        "--quiet",
        GITHUB_REPO_GIT_URL,
        tag_ref("v1.2.3"),
    )

    assert urlopen_calls.count(("urlopen", GITHUB_TAGS_ATOM_URL, {"timeout": 10})) == 1
    assert urlopen_calls.count(("urlopen", GITHUB_TAG_TREE_URL, {"timeout": 10})) == 1
    assert (
        urlopen_calls.count(("urlopen", GITHUB_SUBMODULES_URL, {"timeout": 10})) == 1
    )
    assert urlopen_calls.count(("urlopen", GITHUB_LICENSE_URL, {"timeout": 10})) == 1
    assert check_output_calls == [
        ("check_output", resolve_cmd, {}),
        ("check_output", expected_prefetch_cmd, {}),
    ]


@pytest.mark.parametrize(
    (
        "latest_tag",
        "resolved",
        "expected_commit",
        "expected_version",
        "expected_tag",
        "expected_prefetch_ref",
    ),
    [
        (
            None,
            None,
            "commit-head",
            "0-unstable-2024-05-06",
            None,
            "commit-head",
        ),
        (
            "v1.2.3",
            ("release-commit", BOUNDARY_DATE),
            "release-commit",
            "1.2.3",
            "v1.2.3",
            tag_ref("v1.2.3"),
        ),
    ],
)
def test_prefetch_plugin_uses_real_github_repo_path_without_duplicate_submodule_check(
    monkeypatch: pytest.MonkeyPatch,
    latest_tag: str | None,
    resolved: tuple[str, datetime] | None,
    expected_commit: str,
    expected_version: str,
    expected_tag: str | None,
    expected_prefetch_ref: str,
) -> None:
    repo = update.RepoGitHub("owner", "repo", "")
    get_latest_tag = Mock(
        return_value=latest_tag
    )
    latest_commit = Mock(side_effect=AssertionError("unexpected latest_commit"))
    if latest_tag is None:
        latest_commit = Mock(return_value=("commit-head", BOUNDARY_DATE))
    resolve_ref = Mock(
        return_value=resolved
    )
    has_submodules = Mock(return_value=False)
    prefetch_github = Mock(return_value="sha256-github")
    base_prefetch = Mock(side_effect=AssertionError("unexpected git prefetch"))
    get_license_spdx_id = Mock(return_value="MIT")
    monkeypatch.setattr(repo, "get_latest_tag", get_latest_tag)
    monkeypatch.setattr(repo, "latest_commit", latest_commit)
    monkeypatch.setattr(repo, "resolve_ref", resolve_ref)
    monkeypatch.setattr(repo, "has_submodules", has_submodules)
    monkeypatch.setattr(repo, "prefetch_github", prefetch_github)
    monkeypatch.setattr(update.Repo, "prefetch", base_prefetch)
    monkeypatch.setattr(repo, "get_license_spdx_id", get_license_spdx_id)

    fetched, redirect = update.prefetch_plugin(
        update.PluginDesc(repo, update.AUTO_BRANCH, None),
        cache=FakeCache(),
    )

    assert redirect is None
    assert fetched == plugin(
        name="repo",
        commit=expected_commit,
        has_submodules=False,
        sha256="sha256-github",
        version=expected_version,
        date=BOUNDARY_DATE,
        last_tag=latest_tag,
        tag=expected_tag,
        license="MIT",
    )
    get_latest_tag.assert_called_once_with()
    if latest_tag is None:
        latest_commit.assert_called_once_with()
        resolve_ref.assert_not_called()
    else:
        latest_commit.assert_not_called()
        resolve_ref.assert_called_once_with(tag_ref("v1.2.3"))
    has_submodules.assert_called_once_with()
    prefetch_github.assert_called_once_with(expected_prefetch_ref)
    base_prefetch.assert_not_called()
    get_license_spdx_id.assert_called_once_with()


def test_check_results_rewrites_redirected_plugin_name() -> None:
    old_desc = plugin_desc(FakeRepo(name="old-repo"))
    redirect = FakeRepo(name="new-repo", uri="https://example.com/owner/new-repo")
    fetched = plugin(name="old-repo")

    plugins, redirects = update.check_results([(old_desc, fetched, redirect)])

    assert redirects == {old_desc: redirect}
    new_desc, new_plugin = plugins[0]
    assert new_desc.repo is redirect
    assert new_desc.name == "new-repo"
    assert new_plugin.name == "new-repo"


def test_github_as_nix_uses_tag_when_available() -> None:
    assert (
        update.RepoGitHub("owner", "repo", "").as_nix(
            plugin(commit="abcdef", sha256="sha256-example", tag="v1.2.3")
        )
        == """fetchFromGitHub {
      owner = "owner";
      repo = "repo";
      tag = "v1.2.3";
      hash = "sha256-example";
    }"""
    )


def test_github_as_nix_uses_rev_and_submodules_without_tag() -> None:
    assert (
        update.RepoGitHub("owner", "repo", "").as_nix(
            plugin(commit="abcdef", has_submodules=True, sha256="sha256-example")
        )
        == """fetchFromGitHub {
      owner = "owner";
      repo = "repo";
      rev = "abcdef";
      hash = "sha256-example";
      fetchSubmodules = true;
    }"""
    )
