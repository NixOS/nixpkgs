# shellcheck shell=bash

swiftpm_addCVars() {
    swiftLibDir='.*/lib/swift\(_static\)?/\(host\|@swiftPlatform@\)\(/plugins\|/plugins/testing\|/testing\)?$'
    while IFS= read -d "" d; do
        # Avoid adding paths that have already been added
        if [[ "${swiftpmFlags-}" =~ \ $d\  ]]; then
            continue
        fi
        # Only add the folder if it actually contains Swift modules.
        if [ -n "$(ls "$d"/*.swiftmodule)" ]; then
            appendToVar swiftpmFlags -Xswiftc -I -Xswiftc "$d"
        fi
        # Compiler plugins
        if [[ "$d" =~ plugins(/testing)?$ && -n "$(ls "$d"/*@sharedLibrary@)" ]]; then
            appendToVar swiftpmFlags -Xswiftc -plugin-path -Xswiftc "$d"
        fi
    done < <(find "$1" -type d -and -regex "$swiftLibDir" -print0)
}

addEnvHooks "$targetOffset" swiftpm_addCVars

# Build using 'swift-build'.
swiftpmBuildPhase() {
    runHook preBuild

    local buildCores=1
    if [ "${enableParallelBuilding-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        -j "$buildCores"
        -c "${swiftpmBuildConfig-release}"
        -Xswiftc -module-cache-path -Xswiftc "$NIX_BUILD_TOP/module-cache"
    )
    concatTo flagsArray swiftpmFlags swiftpmFlagsArray

    echoCmd 'SwiftPM flags' "${flagsArray[@]}"
    TERM=dumb swift-build --disable-sandbox "${flagsArray[@]}"

    runHook postBuild
}

if [ -z "${dontUseSwiftpmBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=swiftpmBuildPhase
fi

# Check using 'swift-test'.
swiftpmCheckPhase() {
    runHook preCheck

    local buildCores=1
    if [ "${enableParallelBuilding-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        -j "$buildCores"
        -c "${swiftpmBuildConfig-release}"
    )
    concatTo flagsArray swiftpmFlags swiftpmFlagsArray

    echoCmd 'check flags' "${flagsArray[@]}"
    TERM=dumb swift test "${flagsArray[@]}"

    runHook postCheck
}

if [ -z "${dontUseSwiftpmCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=swiftpmCheckPhase
fi

# Helper used to find the binary output path.
# Useful for performing the installPhase of swiftpm packages.
swiftpmBinPath() {
    local flagsArray=(
        -c "${swiftpmBuildConfig-release}"
    )
    concatTo flagsArray swiftpmFlags swiftpmFlagsArray

    swift-build --show-bin-path "${flagsArray[@]}"
}

# TODO: Support static libraries.
swiftpmInstallPhase() {
    runHook preInstall

    local products=$(swiftpmBinPath)
    while IFS= read -d "" exe; do
        install -D -m 755 "$products/$exe" "${!outputBin}/bin/$exe"
    done < <(swift-package dump-package | @jq@ --raw-output0 '.products[] | select(.type | has("executable")) | .name')

    local libsToInstall=()
    local modulesToInstall=()

    while IFS= read -d "" library; do
        if [ -e "$products/lib$library@sharedLibrary@" ]; then
            if isMachO "$products/lib$library@sharedLibrary@"; then
                @install_name_tool@ "$products/lib$library@sharedLibrary@" \
                    -id "${!outputLib}/lib/lib$library@sharedLibrary@"
            fi
            appendToVar libsToInstall "$products/lib$library@sharedLibrary@"
        fi
        if [ -e "$products/$library.swiftmodule" ]; then
            appendToVar modulesToInstall "$products/$library.swiftmodule"
        fi
        if [ -e "$products/Modules/$library.swiftmodule" ]; then
           appendToVar modulesToInstall "$products/Modules/$library.swiftmodule"
        fi
    done < <(swift-package dump-package | @jq@ --raw-output0 '.products[] | select(.type | has("library")) | .name')

    if [ -n "${libsToInstall}" ]; then
        install -D -t "${!outputLib}/lib" "${libsToInstall[@]}"
        # Only install modules if there are any library products.
        if [ -n "${modulesToInstall}" ]; then
            install -D -t "${!outputInclude}/lib/swift/@swiftPlatform@" "${modulesToInstall[@]}"
        fi
    fi

    runHook postInstall
}

if [ -z "${dontUseSwiftpmInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=swiftpmInstallPhase
fi

# Based on CMake’s setup-hook
makeSwiftPMFindLibs() {
    local -A swiftpmLibFlags
    isystem_seen=
    iframework_seen=
    for flag in ${NIX_CFLAGS_COMPILE-}; do
        if test -n "$isystem_seen" && test -d "$flag"; then
            isystem_seen=
            swiftpmLibFlags["${flag}"]="-Xcc -isystem -Xcc"
        elif test -n "$iframework_seen" && test -d "$flag"; then
            iframework_seen=
            swiftpmLibFlags["${flag}"]="-Xcc -iframework -Xcc"
        else
            isystem_seen=
            iframework_seen=
            case $flag in
            -I*)
                swiftpmLibFlags["${flag:2}"]="-Xcc -I -Xcc"
                ;;
            -L*)
                swiftpmLibFlags["${flag:2}"]="-Xlinker -L -Xlinker"
                ;;
            -F*)
                swiftpmLibFlags["${flag:2}"]="-Xcc -F -Xcc"
                ;;
            -isystem)
                isystem_seen=1
                ;;
            -iframework)
                iframework_seen=1
                ;;
            esac
        fi
    done
    for flag in "${!swiftpmLibFlags[@]}"; do
        appendToVar swiftpmFlags ${swiftpmLibFlags["${flag}"]} "$flag"
    done
}

# not using setupHook, because it could be a setupHook adding additional
# include flags to NIX_CFLAGS_COMPILE
postHooks+=(makeSwiftPMFindLibs)
