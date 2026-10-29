fixSwiftRpathsIn() {
    local dir=$1

    echo "fixing stdlib rpaths in $dir"

    local -a swiftPaths=(
      @swiftPath@/lib/swift/@swiftPlatform@
      @swiftPath@/usr/lib/swift/@swiftPlatform@
      @swiftPath@/lib
      @swiftPath@/usr/lib
    )
    local stdlibPath=@stdlibPath@/lib

    local f
    while IFS= read -d "" f; do
        if LC_ALL=C isMachO "$f"; then
            local -a rpaths
            IFS= readarray -d $'\n' -t rpaths < <(@objdump@ --macho --rpaths "$f" | tail -n +2)

            local oldPath
            local swiftPath
            for oldPath in "${rpaths[@]}"; do
                local newPath=$oldPath
                for swiftPath in "${swiftPaths[@]}"; do
                    newPath=${newPath/$swiftPath/$stdlibPath}
                done

                # Avoid depending on the SDK because this hook needs to work on Darwin and non-Darwin platforms.
                # Swift Build 6.4 adds an rpath to the SDK, but we don’t have any backdeploy libraries there,
                # so remove it to avoid pulling the SDK into any closure that needs to support backdeploying.
                if [[ "$oldPath" =~ ^@store-dir@/[^-]*-apple-sdk-[0-9]+\.[0-9]+/Toolchains/XcodeDefault\.xctoolchain/usr/lib/swift[^/]*/macosx$ ]]; then
                    echo "deleting SDK rpath $oldPath"
                    @install_name_tool@ "$f" -delete_rpath "$oldPath"
                elif [ "$newPath" != "$oldPath" ]; then
                    echo "$f: replacing toolchain rpath $oldPath with stdlib rpath $newPath"
                    @install_name_tool@ "$f" -rpath "$oldPath" "$newPath"
                fi
            done
        elif isELF "$f"; then
            local -a rpaths
            IFS= readarray -d ':' -t rpaths < <(patchelf --print-rpath "$f" | tr -d $'\n')

            # newRpaths will be built up as each rpath is examined because patchelf can’t patch only one at a time.
            local -a newRpaths=()

            local oldPath
            local swiftPath
            for oldPath in "${rpaths[@]}"; do
                local newPath=$oldPath
                for swiftPath in "${swiftPaths[@]}"; do
                    newPath=${newPath/$swiftPath/$stdlibPath}
                done
                if [ "$newPath" != "$oldPath" ]; then
                    echo "$f: replacing toolchain rpath $oldPath with stdlib rpath $newPath"
                    newRpaths+=("$newPath")
                else
                    newRpaths+=("$oldPath")
                fi
            done

            if [[ "${newRpaths[@]}" != "${rpaths[@]}" ]]; then
                @patchelf@ --set-rpath "$(IFS=:; echo "${newRpaths[*]}")" "$f"
            fi
        fi
    done < <(find "$dir" -type f -print0)
}

fixupOutputHooks+=('fixSwiftRpathsIn $prefix')
