# shellcheck shell=bash
mixConfigureHook() {
  echo "Executing mixConfigureHook"

  runHook preConfigure

  # Copy the source so it can be used by mix projects
  # do this before building to avoid build artifacts but after patching
  # to include any modifications
  mkdir -p "$out/src"
  cp -r "." "$out/src"

  # Symlink all dependencies found in ERL_LIBS since Elixir does not honor ERL_LIBS
  mkdir -p _build/"$MIX_BUILD_PREFIX"/lib
  while read -r -d ':' lib; do
    for dir in "$lib"/*; do
      # Strip version number for directory name if it exists, so naming of
      # all libs matches what mix's expectation.
      dest=$(basename "$dir" | cut -d '-' -f1)
      build_dir="_build/$MIX_BUILD_PREFIX/lib/$dest"
      ((MIX_DEBUG == 1)) && echo "Linking $dir to $build_dir"
      # Symlink libs to _build so that mix can find them when compiling.
      # This is what allows mix to compile the package without searching
      # for dependencies over the network.
      ln -s "$dir" "$build_dir"
    done
  done <<<"$ERL_LIBS:"

  runHook postConfigure
}

if [ -z "${dontCargoConfigure-}" ] && [ -z "${configurePhase-}" ]; then
  configurePhase=mixConfigureHook
fi
