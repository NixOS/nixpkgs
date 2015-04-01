addHaxeLibPath() {
    addToSearchPath HAXELIB_PATH "$1/lib/haxe"
}

envHooks+=(addHaxeLibPath)
