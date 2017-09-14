addHaxeLibPath() {
  if [ ! -d "$1/lib/haxe/std" ]; then
    addToSearchPath HAXELIB_PATH "$1/lib/haxe"
  fi
}

envHooks+=(addHaxeLibPath)
