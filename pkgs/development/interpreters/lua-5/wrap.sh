# Inspired by python/wrapper.nix
# Wrapper around wrapLuaProgramsIn, below. The $luaPath
# variable is passed in from the buildLuarocksPackage function.
set -e

source @lua@/nix-support/utils.sh

wrapLuaPrograms() {
  wrapLuaProgramsIn "$out/bin" "$out $luaPath"
}

# Builds environment variables like LUA_PATH and PATH walking through closure
# of dependencies.
buildLuaPath() {
  local luaPath="$1"
  local path

  # Create an empty table of paths (see doc on loadFromPropagatedInputs
  # for how this is used). Build up the program_PATH and program_LUA_PATH
  # variables.
  declare -A luaPathsSeen=()
  program_PATH=
  luaPathsSeen["@lua@"]=1
  addToSearchPath program_PATH @lua@/bin
  for path in $luaPath; do
    addToLuaPath "$path"
  done
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
    # Strip suffix, like "3" or "2.7m" -- we don't have any choice on which
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

# Adds the lib and bin directories to the LUA_PATH and PATH variables,
# respectively. Recurses on any paths declared in
# `propagated-native-build-inputs`, while avoiding duplicating paths by
# flagging the directories it has visited in `luaPathsSeen`.
loadFromPropagatedInputs() {
  local dir="$1"
  # Stop if we've already visited here.
  if [ -n "${luaPathsSeen[$dir]}" ]; then
    return
  fi
  luaPathsSeen[$dir]=1

  addToLuaPath "$dir"
  addToSearchPath program_PATH $dir/bin

  # Inspect the propagated inputs (if they exist) and recur on them.
  local prop="$dir/nix-support/propagated-native-build-inputs"
  if [ -e "$prop" ]; then
    local new_path
    for new_path in $(cat $prop); do
      loadFromPropagatedInputs "$new_path"
    done
  fi
}
