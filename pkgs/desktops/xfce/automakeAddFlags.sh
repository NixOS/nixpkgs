automakeAddFlags() {
    local file="$1"
    local target="$2"
    local source="$3"

    sed "/$target/a\$($source) \\\\" -i $file
}
