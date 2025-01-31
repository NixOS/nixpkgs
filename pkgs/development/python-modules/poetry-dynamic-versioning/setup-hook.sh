version-pretend-hook() {
  echo "Setting POETRY_DYNAMIC_VERSIONING_BYPASS to $version"
  export POETRY_DYNAMIC_VERSIONING_BYPASS=$version
}

if [ -z "${dontBypassPoetryDynamicVersioning-}" ]; then
  preBuildHooks+=(version-pretend-hook)
fi
