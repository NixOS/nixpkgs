qmakeConfigurePhase() {
    runHook preConfigure

    qmake PREFIX=$out $qmakeFlags

    runHook postConfigure
}

if [ -z "$dontUseQmakeConfigure" -a -z "$configurePhase" ]; then
    configurePhase=qmakeConfigurePhase
fi

_qtModuleMultioutDevsPre() {
    # We cannot simply set these paths in configureFlags because libQtCore retains
    # references to the paths it was built with.
    moveToOutput "bin" "${!outputDev}"
    moveToOutput "include" "${!outputDev}"

    # The destination directory must exist or moveToOutput will do nothing
    mkdir -p "${!outputDev}/share"
    moveToOutput "share/doc" "${!outputDev}"
}

_qtModuleMultioutDevsPost() {
    # Move libtool archives and qmake project files to $dev/lib
    if [ "z${!outputLib}" != "z${!outputDev}" ]; then
        pushd "${!outputLib}"
        if [ -d "lib" ]; then
            find lib \( -name '*.a' -o -name '*.la' -o -name '*.prl' \) -print0 | \
                while read -r -d $'\0' file; do
                    mkdir -p "${!outputDev}/$(dirname "$file")"
                    mv "${!outputLib}/$file" "${!outputDev}/$file"
                done
        fi
        popd
    fi
}

if [ -n "$NIX_QT_SUBMODULE" ]; then
    preFixupHooks+=(_qtModuleMultioutDevsPre)
    postFixupHooks+=(_qtModuleMultioutDevsPost)
fi
