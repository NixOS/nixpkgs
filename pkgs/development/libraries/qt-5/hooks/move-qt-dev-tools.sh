updateToolPath() {
    local tool="$1"
    local target="$2"
    local original="${!outputBin}/$tool"
    local actual="${!outputDev}/$tool"
    if grep -q "$original" "$target"; then
        echo "updateToolPath: Updating \`$original' in \`$target\'..."
        sed -i "$target" -e "s|$original|$actual|"
    fi
}

moveQtDevTools() {
    if [ -n "$devTools" ]; then
        for tool in $devTools; do
            moveToOutput "$tool" "${!outputDev}"
        done

        if [ -d "${!outputDev}/mkspecs" ]; then
            find "${!outputDev}/mkspecs" -name '*.pr?' | while read pr_; do
                for tool in $devTools; do
                    updateToolPath "$tool" "$pr_"
                done
            done
        fi

        if [ -d "${!outputDev}/lib/cmake" ]; then
            find "${!outputDev}/lib/cmake" -name '*.cmake' | while read cmake; do
                for tool in $devTools; do
                    updateToolPath "$tool" "$cmake"
                done
            done
        fi
    fi
}
