fixSwiftRpathsIn() {
    local dir=$1

    local swiftPath=@swiftPath@/lib
    local swiftPathForPlatform=@swiftPath@/lib/swift/@swiftPlatform@
    local stdlibPath=@stdlibPath@/lib

    local f
    while IFS= read -d "" f; do
        if LC_ALL=C isMachO "$f"; then
            IFS= readarray -d $'\n' -t rpaths < <(@objdump@ --macho --rpaths "$f" | tail -n +2)
            for oldPath in "${rpaths[@]}"; do
                local newPath=${oldPath/$swiftPathForPlatform/$stdlibPath}
                newPath=${newPath/$swiftPath/$stdlibPath}
                if [ "$newPath" != "$oldPath" ]; then
                    @install_name_tool@ "$f" -rpath "$oldPath" "$newPath"
                fi
            done
        elif isELF "$f"; then
            local oldRpaths=$(@patchelf@ --print-rpath "$f")
            local newRpaths=${oldRpaths/$swiftPathForPlatform/$stdlibPath}
            newRpaths=${newRpaths/$swiftPath/$stdlibPath}
            if [ "$newRpaths" != "$oldRpaths" ]; then
                @patchelf@ --set-rpath "$newRpaths" "$f"
            fi
        fi
    done < <(find "$dir" -type f -print0)
}

fixupOutputHooks+=('fixSwiftRpathsIn $prefix')
