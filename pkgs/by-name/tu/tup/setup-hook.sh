#!/bin/sh

tupConfigure() {
    echo -n CONFIG_TUP_ARCH= >> tup.config
    case "$system" in
    "i686-*")      echo i386 >> tup.config;;
    "x86_64-*")    echo x86_64 >> tup.config;;
    "powerpc-*")   echo powerpc >> tup.config;;
    "powerpc64-*") echo powerpc64 >> tup.config;;
    "ia64-*")      echo ia64 >> tup.config;;
    "alpha-*")     echo alpha >> tup.config;;
    "sparc-*")     echo sparc >> tup.config;;
    "aarch64-*")   echo arm64 >> tup.config;;
    "arm*")        echo arm >> tup.config;;
    esac

    echo "${tupConfig-}" >> tup.config

    tup init
    tup generate --verbose tupBuild.sh
}

tupConfigurePhase() {
    runHook preConfigure
    tupConfigure
    runHook postConfigure
}

if [ -z "${dontUseTupConfigure-}" -a -z "${configurePhase-}" ]; then
    configurePhase=tupConfigurePhase
fi

tupBuild() {
    pushd .
    ./tupBuild.sh
    popd
}

tupBuildPhase() {
    runHook preBuild
    tupBuild
    runHook postBuild
}

if [ -z "${dontUseTupBuild-}" -a -z "${buildPhase-}" ]; then
    buildPhase=tupBuildPhase
fi
