# NOTE: Open bugs in Pydantic like https://github.com/pydantic/pydantic/issues/8984 prevent the full switch to the type
# keyword introduced in Python 3.12.
import re
from collections.abc import Mapping, Sequence
from logging import Logger
from pathlib import Path
from typing import Annotated, Final, Self, override
from urllib import request

from pydantic import Field, field_validator, model_validator

from cuda_redist_lib.extra_pydantic import ModelConfigAllowExtra, PydanticObject
from cuda_redist_lib.extra_types import (
    CudaVariant,
    Date,
    IgnoredRedistPlatforms,
    MajorVersion,
    Md5,
    PackageName,
    PackageNameTA,
    RedistName,
    RedistPlatform,
    RedistPlatforms,
    RedistUrlPrefix,
    Sha256,
    Version,
    VersionTA,
)
from cuda_redist_lib.logger import get_logger

logger: Final[Logger] = get_logger(__name__)


class NvidiaPackage(PydanticObject):
    relative_path: Annotated[Path, Field(description="Relative path to the package from the index URL.")]
    sha256: Annotated[Sha256, Field(description="SHA256 hash of the package.")]
    md5: Annotated[Md5, Field(description="MD5 hash of the package.")]
    size: Annotated[
        str,
        Field(description="Size of the package in bytes, as a string.", pattern=r"\d+"),
    ]


class NvidiaReleaseCommon(PydanticObject):
    name: Annotated[str, Field(description="Full name and description of the release.")]
    license: Annotated[str, Field(description="License under which the release is distributed.")]
    license_path: Annotated[
        None | Path,
        Field(description="Relative path to the license file.", default=None),
    ]
    version: Annotated[Version, Field(description="Version of the release.")]

    def packages(
        self,
    ) -> Mapping[RedistPlatform, NvidiaPackage | Mapping[CudaVariant, NvidiaPackage]]:
        raise NotImplementedError()


def check_extra_keys_are_platforms[T: NvidiaReleaseCommon](self: T) -> T:
    """
    Ensure that all redistributable platforms are present as keys. Additionally removes ignored platforms from the
    extra fields.

    This is to avoid the scenario wherein the platforms are updated but this class is not.
    """
    if not self.__pydantic_extra__:
        raise ValueError("No redistributable platforms found.")

    # Remove ignored platforms
    for platform in IgnoredRedistPlatforms & self.__pydantic_extra__.keys():
        del self.__pydantic_extra__[platform]  # pyright: ignore[reportArgumentType]

    # Check for keys which are not platforms
    if unexpected_keys := self.__pydantic_extra__.keys() - RedistPlatforms:
        unexpected_keys_str = ", ".join(sorted(unexpected_keys))
        raise ValueError(f"Unexpected platform key(s) encountered: {unexpected_keys_str}")

    return self


# Does not have or use `cuda_variant` field
# Does not have a `source` platform
class NvidiaReleaseV2(NvidiaReleaseCommon):
    model_config = ModelConfigAllowExtra
    __pydantic_extra__: dict[  # pyright: ignore[reportIncompatibleVariableOverride]
        RedistPlatform,  # NOTE: This is an invariant we must maintain
        NvidiaPackage,
    ]

    @model_validator(mode="after")
    def check_extra_keys_are_platforms(self) -> Self:
        return check_extra_keys_are_platforms(self)

    @override
    def packages(self) -> Mapping[RedistPlatform, NvidiaPackage]:
        return self.__pydantic_extra__


# Has `cuda_variant` field
class NvidiaReleaseV3(NvidiaReleaseCommon):
    model_config = ModelConfigAllowExtra
    __pydantic_extra__: dict[  # pyright: ignore[reportIncompatibleVariableOverride]
        RedistPlatform,  # NOTE: This is an invariant we must maintain
        NvidiaPackage | Mapping[CudaVariant, NvidiaPackage],  # NOTE: `source` does not use cuda variants
    ]

    cuda_variant: Annotated[
        Sequence[MajorVersion],
        Field(description="CUDA variants supported by the release."),
    ]

    @field_validator("cuda_variant", mode="after")
    @classmethod
    def validate_cuda_variant(cls, value: Sequence[MajorVersion]) -> Sequence[MajorVersion]:
        if value == []:
            raise ValueError("`cuda_variant` cannot be an empty list.")
        return value

    @model_validator(mode="after")
    def check_extra_keys_are_platforms(self) -> Self:
        return check_extra_keys_are_platforms(self)

    @model_validator(mode="after")
    def check_source_is_present(self) -> Self:
        """
        Ensure that the `source` platform is exclusive with all the others.
        """
        if "source" in self.__pydantic_extra__:
            if len(self.__pydantic_extra__) > 1:
                raise ValueError("The `source` platform is exclusive with all the others.")

            if self.cuda_variant != []:
                raise ValueError("The `source` platform requires `cuda_variant` be empty.")

        return self

    @model_validator(mode="after")
    def check_extra_have_cuda_variant_keys(self) -> Self:
        """
        Ensure the values of the extra fields are objects keyed by CUDA variant.
        """
        allowed_cuda_variants = {f"cuda{major_version}" for major_version in self.cuda_variant}
        for platform, variants in self.__pydantic_extra__.items():
            if platform == "source" and not isinstance(variants, NvidiaPackage):
                raise ValueError("The `source` platform must have a single package.")
            elif not isinstance(variants, Mapping):
                raise ValueError(f"Platform {platform} does not have a mapping of CUDA variants.")

            # Check for keys which are not CUDA variants
            if unexpected_keys := variants.keys() - allowed_cuda_variants:
                unexpected_keys_str = ", ".join(sorted(unexpected_keys))
                raise ValueError(
                    f"Unexpected CUDA variant(s) encountered for platform {platform}: {unexpected_keys_str}"
                )

        return self

    @override
    def packages(
        self,
    ) -> Mapping[RedistPlatform, NvidiaPackage | Mapping[CudaVariant, NvidiaPackage]]:
        return self.__pydantic_extra__


# A manifest contains many release objects.
class NvidiaManifest(PydanticObject):
    model_config = ModelConfigAllowExtra
    __pydantic_extra__: dict[  # pyright: ignore[reportIncompatibleVariableOverride]
        PackageName,  # NOTE: This is an invariant we must maintain
        NvidiaReleaseV3 | NvidiaReleaseV2,
    ]

    release_date: Annotated[Date, Field(description="Date of the manifest.")]
    release_label: Annotated[None | Version, Field(description="Label of the manifest.", default=None)]
    release_product: Annotated[
        None | RedistName | str,  # NOTE: This should be RedistName, but cublasmp 0.1.0 release does not conform
        Field(
            description="Product name of the manifest.",
            default=None,
        ),
    ]

    @model_validator(mode="after")
    def check_extra_keys_are_package_names(self) -> Self:
        """
        Ensure that all keys in `__pydantic_extra__` are package names.
        """
        if not self.__pydantic_extra__:
            raise ValueError("No redistributable packages found.")

        # Check for keys which are not package names
        for potential_package_name in self.__pydantic_extra__.keys():
            _ = PackageNameTA.validate_strings(potential_package_name)

        return self

    def releases(self) -> Mapping[PackageName, NvidiaReleaseV2 | NvidiaReleaseV3]:
        return self.__pydantic_extra__


# Returns true if the version should be ignored.
def is_ignored_nvidia_manifest(redist_name: RedistName, version: Version) -> None | str:
    match redist_name:
        # These CUDA manifests are old enough that they don't conform to the same structure as the newer ones.
        case "cuda" if version in {
            "11.0.3",
            "11.1.1",
            "11.2.0",
            "11.2.1",
            "11.2.2",
            "11.3.0",
            "11.3.1",
            "11.4.0",
            "11.4.1",
        }:
            return "does not conform to the expected structure"
        # The cuDNN manifests with four-component versions don't have a cuda_variant field.
        # The three-component versions are fine.
        case "cudnn" if len(version.split(".")) == 4:  # noqa: PLR2004
            return "uses lib directory structure instead of cuda variant"
        case _:
            return None


def get_nvidia_manifest_versions(
    redist_name: RedistName, tensorrt_manifest_dir: None | Path = None
) -> Sequence[Version]:
    logger.info("Getting versions for %s", redist_name)
    regex_pattern = re.compile(
        r"""
        redistrib_           # Match 'redistrib_'
        (\d+(?:\.\d+){1,3})  # Capture a version number with 2-4 components
        \.json               # Match '.json'
        """,
        flags=re.VERBOSE,
    )

    # Map major and minor component to the tuple of all components and the version string.
    version_dict: dict[tuple[int, ...], tuple[tuple[int, ...], Version]] = {}

    # For CUDA, and CUDA only, we take only the latest minor version for each major version.
    # For other packages, like cuDNN, we take the latest patch version for each minor version.
    # An example of why we do this: between patch releases of cuDNN, NVIDIA may not offer support for all
    # architecutres! For instance, cuDNN 8.9.5 supports Jetson, but cuDNN 8.9.6 does not.
    num_components: int
    match redist_name:
        case "cuda":
            num_components = 2
        case _:
            num_components = 3

    listing: str
    match redist_name:
        case "tensorrt":
            if tensorrt_manifest_dir is None:
                raise ValueError("Must provide the path to the tensorrt manifests")
            listing = "\n".join(
                redistrib_path.name for redistrib_path in tensorrt_manifest_dir.iterdir() if redistrib_path.is_file()
            )
        case _:
            with request.urlopen(f"{RedistUrlPrefix}/{redist_name}/redist/index.html") as response:
                listing = response.read().decode("utf-8")

    for raw_version_match in regex_pattern.finditer(listing):
        raw_version: str = raw_version_match.group(1)
        version = VersionTA.validate_strings(raw_version)

        reason = is_ignored_nvidia_manifest(redist_name, version)
        if reason:
            logger.info("Ignoring manifest %s version %s: %s", redist_name, version, reason)
            continue

        # Take only the latest minor version for each major version.
        components = tuple(map(int, version.split(".")))
        existing_components, _ = version_dict.get(components[:num_components], (None, None))
        if existing_components is None or components > existing_components:
            version_dict[components[:num_components]] = (components, version)

    return [version for _, version in version_dict.values()]


def get_nvidia_manifest_str(
    redist_name: RedistName, version: Version, tensorrt_manifest_dir: None | Path = None
) -> bytes:
    logger.info("Getting manifest for %s %s", redist_name, version)
    match redist_name:
        case "tensorrt":
            if tensorrt_manifest_dir is None:
                raise ValueError("Must provide the path to the tensorrt manifests")
            return (tensorrt_manifest_dir / f"redistrib_{version}.json").read_bytes()
        case _:
            return request.urlopen(f"{RedistUrlPrefix}/{redist_name}/redist/redistrib_{version}.json").read()


def get_nvidia_manifest(
    redist_name: RedistName, version: Version, tensorrt_manifest_dir: None | Path = None
) -> NvidiaManifest:
    return NvidiaManifest.model_validate_json(get_nvidia_manifest_str(redist_name, version, tensorrt_manifest_dir))
