# shellcheck shell=bash

mixFodDepsPostUnpack() {
  echo "Executing mixFodDepsPostUnpack"

  if [ -n "${mixFodDeps-}" ]; then
    # Compilation of the dependencies will require that the dependency path is
    # writable, thus a copy to the $TEMPDIR is inevitable here.
    export MIX_DEPS_PATH="$TEMPDIR/deps"
    cp --no-preserve=mode -R "${mixFodDeps}" "$MIX_DEPS_PATH"
  fi

  echo "Finished mixFodDepsPostUnpack"
}

mixFodDepsPostConfigure() {
  echo "Executing mixFodDepsPostConfigure"

  if [ -n "${mixFodDeps-}" ]; then
    # Symlink deps to build root. Allows for mixFodDeps Phoenix projects to
    # find javascript assets.
    ln -s "$MIX_DEPS_PATH" ./deps
  fi

  echo "Finished mixFodDepsPostConfigure"
}

postUnpackHooks+=(mixFodDepsPostUnpack)
postConfigureHooks+=(mixFodDepsPostConfigure)
