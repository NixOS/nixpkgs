#!/bin/bash

declare -gA luaPathsSeen=()

# shellcheck disable=SC2164,SC2041
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

  # export only if we haven't already got this dir in the search path
  if [[ ${!varName-} == *"$absPattern"* ]]; then return; fi

  # if the path variable has not yet been set, initialize it to ";;"
  # this is a magic value that will be replaced by the default,
  # allowing relative modules to be used even when there are system modules.
  if [[ ! -v "${varName}" ]]; then export "${varName}=;;"; fi

  # export only if the folder contains lua files
  shopt -s globstar

  local adjustedPattern="${absPattern/\?/\*\*\/\*}"
  for _file in $adjustedPattern; do
    export "${varName}=${!varName:+${!varName};}${absPattern}"
    shopt -u globstar
    return;
  done
  shopt -u globstar
}

# used in setup Hooks to load LUA_PATH and LUA_CPATH
# luaEnvHook
luaEnvHook() {
    _addToLuaPath "$1"
}

addToLuaPath() {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    nix_debug "$dir not a directory abort"
    return 0
  fi
  cd "$dir"
  for pattern in @luapathsearchpaths@; do
    addToLuaSearchPathWithCustomDelimiter LUA_PATH "$PWD/$pattern"
  done

  # LUA_CPATH
  for pattern in @luacpathsearchpaths@; do
    addToLuaSearchPathWithCustomDelimiter LUA_CPATH "$PWD/$pattern"
  done
  cd - >/dev/null
}


_addToLuaPath() {
  local dir="$1"

  echo "_addToLuaPath called for dir $dir"

  if [[ ! -d "$dir" ]]; then
    nix_debug "$dir not a directory abort"
    return 0
  fi

# set -x
  # if [ -n "${pythonPathsSeen[$dir]}" ]; then return; fi
  if [[ -n "${luaPathsSeen[$dir]:-}" ]]; then
  # if [ -n "${luaPathsSeen[$dir]}" ]; then
    echo "$dir already parsed"
    return
  fi

  luaPathsSeen["$dir"]=true

  # shellcheck disable=SC2164
  cd "$dir"
  for pattern in @luapathsearchpaths@; do
    addToLuaSearchPathWithCustomDelimiter LUA_PATH "$PWD/$pattern"
  done

  # LUA_CPATH
  for pattern in @luacpathsearchpaths@; do
    addToLuaSearchPathWithCustomDelimiter LUA_CPATH "$PWD/$pattern"
  done

  cd - >/dev/null

  addToSearchPath program_PATH "$dir"/bin

  # Inspect the propagated inputs (if they exist) and recur on them.
  local prop="$dir/nix-support/propagated-build-inputs"
  if [ -e "$prop" ]; then
    local new_path
    for new_path in $(cat $prop); do
        echo "newpath: $new_path"
        _addToLuaPath "$new_path"
    done
  fi

}

# Builds environment variables like LUA_PATH and PATH walking through closure
# of dependencies.
buildLuaPath() {
  local luaPath="$1"
  local path

  echo "BUILD_LUA_PATH"

#   # set -x
#   # Create an empty table of paths (see doc on loadFromPropagatedInputs
#   # for how this is used). Build up the program_PATH and program_LUA_PATH
#   # variables.
  # declare -gA luaPathsSeen=()
#   # shellcheck disable=SC2034
  program_PATH=
  luaPathsSeen["@lua@"]=1
#   addToSearchPath program_PATH @lua@/bin
  for path in $luaPath; do
    _addToLuaPath "$path"
  done
}


