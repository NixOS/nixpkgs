import io
import json
from datetime import datetime

import nixpkgs_plugin_update as update


GITHUB_REPO_URL = "https://github.com/owner/repo"


class JsonResponse(io.BytesIO):
    def __init__(self, data: object) -> None:
        payload = data if isinstance(data, str) else json.dumps(data)
        super().__init__(payload.encode("utf-8"))

    def __enter__(self) -> "JsonResponse":
        return self

    def __exit__(self, *_args: object) -> None:
        self.close()


class BinaryResponse(io.BytesIO):
    def __init__(
        self, data: bytes = b"", url: str = "https://github.com/owner/repo"
    ) -> None:
        super().__init__(data)
        self.url = url

    def __enter__(self) -> "BinaryResponse":
        return self

    def __exit__(self, *_args: object) -> None:
        self.close()

    def geturl(self) -> str:
        return self.url

class FakeRepo:
    def __init__(
        self,
        *,
        name: str = "repo",
        latest_tag: str | None = None,
        latest_commit: tuple[str, datetime] | None = None,
        refs: dict[str, tuple[str, datetime]] | None = None,
        uri: str = "https://example.com/owner/repo",
        license_spdx_id: str | None = None,
        has_submodules: bool = False,
        redirect: update.Repo | None = None,
    ) -> None:
        self.uri = uri
        self._name = name
        self._branch = ""
        self.redirect = redirect
        self.latest_tag = latest_tag
        self.latest_commit_result = latest_commit
        self.refs = refs or {}
        self.license_spdx_id = license_spdx_id
        self.has_submodules_result = has_submodules
        self.get_latest_tag_calls = 0
        self.latest_commit_calls = 0
        self.resolve_ref_calls: list[str] = []
        self.has_submodules_calls = 0
        self.prefetch_calls: list[str] = []
        self.prefetch_call_details: list[tuple[str, bool | None]] = []
        self.license_calls = 0

    @property
    def name(self) -> str:
        return self._name

    def get_latest_tag(self) -> str | None:
        self.get_latest_tag_calls += 1
        return self.latest_tag

    def latest_commit(self) -> tuple[str, datetime]:
        self.latest_commit_calls += 1
        if self.latest_commit_result is None:
            raise AssertionError("latest_commit called without configured result")
        return self.latest_commit_result

    def resolve_ref(self, ref: str) -> tuple[str, datetime]:
        self.resolve_ref_calls.append(ref)
        if ref not in self.refs:
            raise AssertionError(f"resolve_ref called with unexpected ref: {ref}")
        return self.refs[ref]

    def has_submodules(self) -> bool:
        self.has_submodules_calls += 1
        return self.has_submodules_result

    def prefetch(self, ref: str, has_submodules: bool | None = None) -> str:
        self.prefetch_calls.append(ref)
        self.prefetch_call_details.append((ref, has_submodules))
        return "sha256-prefetched"

    def get_license_spdx_id(self, fallback_license: str | None = None) -> str | None:
        self.license_calls += 1
        return self.license_spdx_id or fallback_license


class FakeCache:
    def __init__(self, values: dict[str, update.Plugin] | None = None) -> None:
        self.values = values or {}

    def __getitem__(self, key: str) -> update.Plugin | None:
        return self.values.get(key)

    def __setitem__(self, key: str, value: update.Plugin | None) -> None:
        if value is None:
            raise AssertionError("Cache values must be Plugin instances")
        self.values[key] = value

    def __bool__(self) -> bool:
        return True

def plugin_desc(repo: FakeRepo, branch: str = update.AUTO_BRANCH) -> update.PluginDesc:
    return update.PluginDesc(repo=repo, branch=branch, alias=None)


def plugin(
    *,
    name: str = "repo",
    commit: str = "commit-current",
    has_submodules: bool = False,
    sha256: str = "sha256-current",
    version: str = "1.0.0",
    date: datetime | None = None,
    last_tag: str | None = "v1.0.0",
    tag: str | None = None,
    license: str | None = None,
) -> update.Plugin:
    return update.Plugin(
        name=name,
        commit=commit,
        has_submodules=has_submodules,
        sha256=sha256,
        version=version,
        date=date,
        last_tag=last_tag,
        tag=tag,
        license=license,
    )
