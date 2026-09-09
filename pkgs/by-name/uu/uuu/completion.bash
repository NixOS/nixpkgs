_uuu_autocomplete() {
    COMPREPLY=($(uuu $1 $2 $3))
}
complete -o nospace -F _uuu_autocomplete  uuu
