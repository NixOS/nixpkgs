import tarfile
import sys


def process_columns(line: list[str]) -> tuple[str, list[str]]:
    match line:
        case [name, h_prefix, nrbytes, flags]:
            return (h_prefix, flags.lower().split(","))
        case other:
            raise Exception("Unsupported hashes.conf line format", other)


def find_tar_file(tar: tarfile.TarFile, requested_name: str):
    """Attempts to find a single file with given name in tarball."""
    all_names = tar.getnames()

    if requested_name in all_names:
        return requested_name

    requested_suffix = f"/{requested_name}"
    candidate_names = [name for name in all_names if name.endswith(requested_suffix)]
    match candidate_names:
        case [real_name]:
            return real_name
        case other:
            raise KeyError(
                f"Could not locate a single {requested_name} in the contents of the tarball."
            )


hashes_path = "lib/hashes.conf"


def main() -> None:
    match sys.argv:
        case [_name, src, enable_hashes, "--", *enabled_crypt_scheme_ids]:
            pass
        case other:
            raise Exception(
                "Incorrect number of arguments. Usage: check_passthru_matches.py <src> <enable_hashes> -- <enabled_crypt_scheme_ids...>"
            )

    with tarfile.open(src, "r") as tar:
        real_hashes_path = find_tar_file(tar, hashes_path)
        config = tar.extractfile(real_hashes_path).read().decode("utf-8")

    formats = [
        process_columns(columns)
        for line in config.splitlines()
        if not line.startswith("#") and len(columns := line.split()) > 0
    ]
    expected_supported_formats = set(
        prefix
        for (prefix, flags) in formats
        if enable_hashes in flags or enable_hashes == "all"
    )
    passthru_supported_schemes = set(
        f"${scheme}$" for scheme in enabled_crypt_scheme_ids
    )

    assert (
        len(expected_supported_formats - passthru_supported_schemes) == 0
    ), f"libxcrypt package enables the following crypt schemes that are not listed in passthru.enabledCryptSchemeIds: {expected_supported_formats - passthru_supported_schemes}"
    assert (
        len(passthru_supported_schemes - expected_supported_formats) == 0
    ), f"libxcrypt package lists the following crypt schemes in passthru.enabledCryptSchemeIds that are not supported: {passthru_supported_schemes - expected_supported_formats}"


if __name__ == "__main__":
    main()
