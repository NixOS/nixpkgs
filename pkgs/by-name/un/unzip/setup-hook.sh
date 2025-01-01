unpackCmdHooks+=(_tryUnzip)
_tryUnzip() {
    if ! [[ "$curSrc" =~ \.zip$ ]]; then return 1; fi

    # UTF-8 locale is needed for unzip on glibc to handle UTF-8 symbols:
    #   https://github.com/NixOS/nixpkgs/issues/176225#issuecomment-1146617263
    # Otherwise unzip unpacks escaped file names as if '-U' options was in effect.
    #
    # Pick en_US.UTF-8 as most possible to be present on glibc, musl and darwin.
    LANG=en_US.UTF-8 unzip -qq "$curSrc"
}
