# set -e

nix_print() {
    if (( "${NIX_DEBUG:-0}" >= $1 )); then
        echo "$2"
    fi
}

nix_debug() {
    nix_print 3 "$1"
}

addToLuaSearchPathWithCustomDelimiter() {
    # local delimiter="$1"
    local varName="$1"
    local pattern="$2"
    # delete longest match starting from
    local topDir="${pattern%%\?*}"

    # export only if the folder exists else LUA_PATH grows too big
    if  [ ! -d "$topDir" ]; then return; fi
    # check for duplicate
    if [[ $LUA_PATH = *"$pattern"* ]]; then return; fi

    export "${varName}=${!varName:+${!varName};}${pattern}"
}

addToLuaPath() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        nix_debug "$dir not a directory abort"
        return 0
    fi
    cd "$dir"
    for pattern in @luapathsearchpaths@;
    do
        addToLuaSearchPathWithCustomDelimiter LUA_PATH "$PWD/$pattern"
    done

    # LUA_CPATH
    for pattern in @luacpathsearchpaths@;
    do
        addToLuaSearchPathWithCustomDelimiter LUA_CPATH "$PWD/$pattern"
    done
    cd -
}

addEnvHooks "$hostOffset" addToLuaPath

