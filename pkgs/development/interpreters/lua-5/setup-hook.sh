# set -e

nix_print() {
    if [ ${NIX_DEBUG:-0} -ge $1 ]; then
        echo "$2"
    fi
}

nix_debug() {
    nix_print 3 "$1"
}

addToLuaSearchPathWithCustomDelimiter() {
    local varName="$1"
    local absPattern="$2"
    # delete longest match starting from the lua placeholder '?'
    local topDir="${absPattern%%\?*}"

    # export only if the folder exists else LUA_PATH grows too big
    if  [ ! -d "$topDir" ]; then return; fi

    export "${varName}=${!varName:+${!varName};}${absPattern}"
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
        addToLuaSearchPathWithCustomDelimiter NIX_LUA_PATH "$PWD/$pattern"
    done

    # LUA_CPATH
    for pattern in @luacpathsearchpaths@;
    do
        addToLuaSearchPathWithCustomDelimiter NIX_LUA_CPATH "$PWD/$pattern"
    done
    cd - >/dev/null
}

addEnvHooks "$hostOffset" addToLuaPath

