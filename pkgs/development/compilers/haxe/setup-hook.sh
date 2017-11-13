addHaxeLibPath() {
  if [ ! -d "$1/lib/haxe/std" ]; then
    prependToSearchPath HAXELIB_PATH "$1/lib/haxe"
  fi
}

envHooks+=(addHaxeLibPath)
