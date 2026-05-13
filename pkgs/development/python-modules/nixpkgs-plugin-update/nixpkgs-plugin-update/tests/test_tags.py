import pytest

import nixpkgs_plugin_update as update


@pytest.mark.parametrize(
    ("tag", "expected"),
    [
        ("v2.5.1", "2.5.1"),
        ("yocto-6.0_M3", "6.0_M3"),
        ("v88.1-1.0.0", "88.1-1.0.0"),
        ("13.2@1", "13.2@1"),
        ("2025-07-10", "2025-07-10"),
        ("v0.10.x", "0.10.x"),
        ("ver.4.2", "4.2"),
        ("vim7.4", "7.4"),
    ],
)
def test_normalize_release_version_accepts_real_world_tags(
    tag: str, expected: str
) -> None:
    assert update.normalize_release_version(tag) == expected


@pytest.mark.parametrize("tag", ["legacy", "sign-test", "pre-nvim-0.10"])
def test_normalize_release_version_rejects_non_release_tags(tag: str) -> None:
    assert update.normalize_release_version(tag) is None


@pytest.mark.parametrize(
    ("tags", "expected"),
    [
        (
            [
                "yocto-4.0.999",
                "yocto-5.0",
                "yocto-5.3.3",
                "yocto-6.0_M3",
                "nightly",
                "sign-test",
            ],
            update.normalize_release_version,
        )
        == "yocto-5.3.3"
    )


def test_select_latest_tag_handles_real_release_candidate_noise() -> None:
    assert (
        update.select_latest_tag(
            [
                "v0.10.0-dev",
                "v0.10.0-rc1",
                "v0.10.0",
                "pre-nvim-0.10",
                "nightly",
            ],
            update.normalize_release_version,
        )
        == "v0.10.0"
    )


def test_select_latest_tag_keeps_date_release_tags_comparable() -> None:
    assert (
        update.select_latest_tag(
            ["2025-07-10", "2025-07-09", "2024-12-31", "stable"],
            update.normalize_release_version,
        )
        == "2025-07-10"
    )


def test_select_latest_tag_falls_back_to_max_invalid_tag() -> None:
    assert update.select_latest_tag(["stable", "release"]) == "stable"


def test_first_release_tag_uses_api_recency_order() -> None:
    assert update.first_release_tag(["nightly", "v1.2.0", "v1.3.0"]) == "v1.2.0"
