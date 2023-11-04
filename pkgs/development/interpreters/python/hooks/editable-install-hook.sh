editableInstallHook() {
    echo "Executing editableInstallHook"
    runHook preShellHook

    # We make a temporary directory to hold the editable install. We don't
    # really have a way to clean it up as it must exist past the shell lifetime
    # for tools like direnv to work properly. However, the total contents are
    # only a few kilobytes (independent of the size of the edited package) and
    # the operating system will clean it up e.g. on reboot.
    tmp_path=$(mktemp -d)
    export PATH="$tmp_path/bin:$PATH"
    export PYTHONPATH="$tmp_path/@pythonSitePackages@:$PYTHONPATH"
    mkdir -p "$tmp_path/@pythonSitePackages@"
    eval "@pythonInterpreter@ -m pip install -e . --prefix $tmp_path \
      --no-build-isolation >&2"

    # Process pth file installed in tmp path. This allows one to actually import
    # the editable installation. Note site.addsitedir appends, not prepends,
    # new paths. Hence, it is not possible to override an existing installation
    # of the package. https://github.com/pypa/setuptools/issues/2612
    export NIX_PYTHONPATH="$tmp_path/@pythonSitePackages@:${NIX_PYTHONPATH-}"

    runHook postShellHook
    echo "Finished executing editableInstallHook"
}

if [ -z "${dontUseEditableInstallHook:-}" ] && [ -z "${shellHook-}" ]; then
    echo "Using editableInstallHook"
    shellHook=editableInstallHook
fi
