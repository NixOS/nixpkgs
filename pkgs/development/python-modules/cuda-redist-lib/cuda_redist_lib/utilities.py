# NOTE: Open bugs in Pydantic like https://github.com/pydantic/pydantic/issues/8984 prevent the full switch to the type
# keyword introduced in Python 3.12.
import base64
from hashlib import sha256
from pathlib import Path

from cuda_redist_lib.extra_types import CudaVariant, PackageName, RedistPlatform, Sha256, SriHash, SriHashTA, Version


def sha256_bytes_to_sri_hash(sha256_bytes: bytes) -> SriHash:
    base64_hash = base64.b64encode(sha256_bytes).decode("utf-8")
    sri_hash = f"sha256-{base64_hash}"
    return SriHashTA.validate_strings(sri_hash)


def sha256_to_sri_hash(sha256: Sha256) -> SriHash:
    """
    Convert a Base16 SHA-256 hash to a Subresource Integrity (SRI) hash.
    """
    return sha256_bytes_to_sri_hash(bytes.fromhex(sha256))


def mk_sri_hash(bs: bytes) -> SriHash:
    """
    Compute a Subresource Integrity (SRI) hash from a byte string.
    """
    return sha256_bytes_to_sri_hash(sha256(bs).digest())


def mk_relative_path(
    package_name: PackageName,
    platform: RedistPlatform,
    version: Version,
    cuda_variant: None | CudaVariant,
) -> Path:
    return (
        Path(package_name)
        / platform
        / "-".join([
            package_name,
            platform,
            (version + (f"_{cuda_variant}" if cuda_variant is not None else "")),
            "archive.tar.xz",
        ])
    )
