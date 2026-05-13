from datetime import datetime, timezone
from pathlib import Path
from unittest.mock import Mock

import pytest

import nixpkgs_plugin_update as update
from helpers import FakeCache, FakeRepo, plugin, plugin_desc


RELEASE_DATE = datetime(2024, 1, 15, tzinfo=timezone.utc)
HEAD_DATE = datetime(2024, 2, 1, tzinfo=timezone.utc)
BOUNDARY_DATE = datetime(2024, 5, 6, tzinfo=timezone.utc)


def tag_ref(tag: str) -> str:
    return f"{update.GIT_TAGS_PREFIX}{tag}"


def test_auto_branch_without_current_plugin_prefers_release() -> None:
    repo = FakeRepo(
        latest_tag="v1.1.0",
        refs={tag_ref("v1.1.0"): ("commit-release", RELEASE_DATE)},
    )

    assert update.select_plugin_target(plugin_desc(repo), None, "v1.1.0") == (
        "commit-release",
        RELEASE_DATE,
        "1.1.0",
        "v1.1.0",
    )


def test_commit_tracked_plugin_newer_than_release_stays_on_commit() -> None:
    repo = FakeRepo(
        latest_commit=("commit-head", HEAD_DATE),
        refs={tag_ref("v1.1.0"): ("commit-release", RELEASE_DATE)},
    )
    current = plugin(
        version="1.0.0-unstable-2024-01-20",
        date=datetime(2024, 1, 20, tzinfo=timezone.utc),
    )

    assert update.select_plugin_target(plugin_desc(repo), current, "v1.1.0") == (
        "commit-head",
        HEAD_DATE,
        "1.1.0-unstable-2024-02-01",
        None,
    )
    assert repo.latest_commit_calls == 1
    assert repo.resolve_ref_calls == [tag_ref("v1.1.0")]


def test_commit_tracked_plugin_equal_to_release_switches_to_release() -> None:
    repo = FakeRepo(
        refs={tag_ref("v1.1.0"): ("commit-release", RELEASE_DATE)},
    )
    current = plugin(
        version="1.0.0-unstable-2024-01-15",
        date=RELEASE_DATE,
    )

    assert update.select_plugin_target(plugin_desc(repo), current, "v1.1.0") == (
        "commit-release",
        RELEASE_DATE,
        "1.1.0",
        "v1.1.0",
    )


def test_no_usable_release_falls_back_to_latest_commit() -> None:
    repo = FakeRepo(latest_commit=("commit-head", HEAD_DATE))

    assert update.select_plugin_target(plugin_desc(repo), None, "prerelease") == (
        "commit-head",
        HEAD_DATE,
        "0-unstable-2024-02-01",
        None,
    )


def test_explicit_branch_bypasses_release_heuristic() -> None:
    branch_date = datetime(2024, 3, 1, tzinfo=timezone.utc)
    repo = FakeRepo(refs={"main": ("commit-main", branch_date)})

    assert update.select_plugin_target(plugin_desc(repo, "main"), None, "v1.1.0") == (
        "commit-main",
        branch_date,
        "1.1.0-unstable-2024-03-01",
        None,
    )


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
    head_date = datetime(2024, 2, 1, tzinfo=timezone.utc)
    repo = FakeRepo(latest_commit=("commit-head", head_date))
    current = plugin(license="Apache-2.0")

    fetched, _redirect = update.prefetch_plugin(
        plugin_desc(repo), current_plugin=current
    )

    assert fetched.license == "Apache-2.0"
    assert repo.license_calls == 0
    assert repo.prefetch_calls == ["commit-head"]
    assert repo.prefetch_call_details == [("commit-head", None)]
    assert repo.get_latest_tag_calls == 1
    assert repo.latest_commit_calls == 1
    assert repo.has_submodules_calls == 1


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
    assert repo.prefetch_call_details == [(tag_ref("v1.1.0"), None)]
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
    assert repo.get_latest_tag_calls == 1
    assert repo.latest_commit_calls == 1
    assert repo.has_submodules_calls == 1
    assert repo.prefetch_call_details == [("commit-head", None)]
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
    assert repo.get_latest_tag_calls == 1
    assert repo.latest_commit_calls == 1
    assert repo.has_submodules_calls == 1
    assert repo.prefetch_call_details == [("commit-head", None)]


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
