# shellcheck shell=bash
#
# Symlink all dependencies found in ERL_LIBS since Elixir does not honor ERL_LIBS

mixBuildDirHook() {
  echo "Executing mixBuildDirHook"

  local lib dir dest build_dir

  mkdir -p _build/"$MIX_BUILD_PREFIX"/lib
  while IFS= read -r -d ':' lib; do
    [ -n "$lib" ] || continue
    for dir in "$lib"/*; do
      [ -d "$dir" ] || continue
      # Strip version number for directory name if it exists, so naming of
      # all libs matches what mix's expectation.
      dest=$(basename "$dir" | cut -d '-' -f1)
      build_dir="_build/$MIX_BUILD_PREFIX/lib/$dest"

      # Symlink libs to _build so that mix can find them when compiling.
      # This is what allows mix to compile the package without searching
      # for dependencies over the network.
      ln -sv "$dir" "$build_dir"
    done
  done <<<"$ERL_LIBS:"

  echo "Finished mixBuildDirHook"
}

preConfigureHooks+=(mixBuildDirHook)
