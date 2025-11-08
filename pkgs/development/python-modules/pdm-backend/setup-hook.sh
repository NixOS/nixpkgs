pdm-version-pretend-hook() {
  if [ -z "${PDM_BUILD_SCM_VERSION-}" ]; then
    echo "Setting PDM_BUILD_SCM_VERSION to $version"
    export PDM_BUILD_SCM_VERSION="$version"
  fi
}

if [ -z "${dontSetPdmBackendVersion-}" ]; then
  preBuildHooks+=(pdm-version-pretend-hook)
fi
