# Inspired by python/wrapper.nix
# Wrapper around wrapLuaProgramsIn, below. The $luaPath
# variable is passed in from the buildLuarocksPackage function.
set -e

source @lua@/nix-support/utils.sh

wrapLuaPrograms() {
  wrapLuaProgramsIn "$out/bin" "$out $luaPath"
}

# with an executable shell script which will set some environment variables
# and then call into the original binary (which has been given a .wrapped suffix).
# luaPath is a list of directories
wrapLuaProgramsIn() {
  local dir="$1"
  local luaPath="$2"
  local f

  buildLuaPath "$luaPath"

  if [ ! -d "$dir" ]; then
    nix_debug "$dir not a directory"
    return
  fi

  nix_debug "wrapping programs in [$dir]"

  # Find all regular files in the output directory that are executable.
  find "$dir" -type f -perm -0100 -print0 | while read -d "" f; do
    # Rewrite "#! .../env lua" to "#! /nix/store/.../lua".
    # Lua to use besides one with this hook anyway.
    if head -n1 "$f" | grep -q '#!.*/env.*\(lua\)'; then
      sed -i "$f" -e "1 s^.*/env[ ]*\(lua\)[^ ]*^#! @executable@^"
    fi

    # wrapProgram creates the executable shell script described
    # above. The script will set LUA_(C)PATH and PATH variables!
    # (see pkgs/build-support/setup-hooks/make-wrapper.sh)
    local -a wrap_args=("$f"
      --prefix PATH ':' "$program_PATH"
      --prefix LUA_PATH ';' "$LUA_PATH"
      --prefix LUA_CPATH ';' "$LUA_CPATH"
    )

    # Add any additional arguments provided by makeWrapperArgs
    # argument to buildLuaPackage.
    # makeWrapperArgs
    local -a user_args="($makeWrapperArgs)"
    local -a wrapProgramArgs=("${wrap_args[@]}" "${user_args[@]}")

    # see setup-hooks/make-wrapper.sh
    wrapProgram "${wrapProgramArgs[@]}"

  done
}
