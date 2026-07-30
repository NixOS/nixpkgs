# shellcheck shell=bash
#
# Symlink all dependencies found in ERL_LIBS since Elixir does not honor ERL_LIBS

mixBuildDirHook() {
  echo "Executing mixBuildDirHook"

  mkdir -p _build/"$MIX_BUILD_PREFIX"/lib
  while read -r -d ':' lib; do
    for dir in "$lib"/*; do
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
