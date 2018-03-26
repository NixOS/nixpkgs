# set -e

nix_print() {
    if (( "${NIX_DEBUG:-0}" >= $1 )); then
        echo "$2"
    fi
}

nix_debug() {
    nix_print 3 "$1"
}

nix_error() {
    nix_print 1 "$1"
}

nix_warn() {
    nix_print 2 "$1"
}
addToLuaSearchPathWithCustomDelimiter() {
    local delimiter="$1"
    local varName="$2"
    local pattern="$3"
    # delete longest match starting from '?'
    local topDir="${pattern%%\?*}"

    # export only if the folder exists else LUA_PATH grows too big
    if  [ -d "$topDir" ]; then
        export "${varName}=${!varName:+${!varName}${delimiter}}${pattern}"
    fi
}

addToLuaSearchPath() {
    addToLuaSearchPathWithCustomDelimiter ";" "$@"
}

startLuaEnvHook() {
    addToLuaPath "$1"
    # echo "LUA_PATH=$LUA_PATH"
    # echo "LUA_CPATH=$LUA_CPATH"
    # echo "program_LUA_PATH=$program_LUA_PATH"
    # echo "program_LUA_CPATH=$program_LUA_CPATH"
}

# Adds the lib and bin directories to the LUA_PATH and PATH variables,
# respectively. Recurses on any paths declared in
# `propagated-native-build-inputs`, while avoiding duplicating paths by
# flagging the directories it has visited in `luaPathsSeen`.
addToLuaPath() {
    local dir="$1"
    # echo " PATTERNS list $dir  @luapathsearchpaths@"

    if [[ ! -d "$dir" ]]; then
        echo "$dir not a directory abort"
        return 0
    fi
    cd $dir
    for pattern in @luapathsearchpaths@;
    do
        addToLuaSearchPath LUA_PATH "$PWD/$pattern"
    done

    # LUA_CPATH
    for pattern in @luacpathsearchpaths@;
    do
        addToLuaSearchPath LUA_CPATH "$PWD/$pattern"
    done
    cd -
}

addEnvHooks "$hostOffset" startLuaEnvHook

