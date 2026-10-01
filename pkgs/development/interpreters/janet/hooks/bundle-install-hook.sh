# shellcheck shell=bash

janetBundleInstallHook() {
    echo "Executing janetBundleInstallHook"

    runHook preInstall

    target=$out/lib/janet

    # Janet expects the last element in JANET_PATH to be the *syspath*
    # But we want to preserve the original ordering, so the old syspath needs to be moved to the front
    if [[ -z "${JANET_PATH-}" ]]; then
        export JANET_PATH=$target
    elif [[ "$JANET_PATH" == *:* ]]; then
        export JANET_PATH="${JANET_PATH##*:}:${JANET_PATH%:*}:$target"
    else
        export JANET_PATH="$JANET_PATH:$target"
    fi

    mkdir -p $target
    janet --install .

    if [ -d "$target/bin" ]; then
        ln -s $target/bin $out
    fi

    if [ -d "$target/man" ]; then
        ln -s $target/man $out
    fi

    runHook postInstall

    echo "Finished janetBundleInstallHook"
}

if [ -z "${installPhase-}" ]; then
    installPhase=janetBundleInstallHook
fi
