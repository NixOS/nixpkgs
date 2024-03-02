version-pretend-hook() {
  echo "Setting PDM_BUILD_SCM_VERSION to $version"
  export PDM_BUILD_SCM_VERSION=$version
}

if [ -z "${dontSetPdmBackendVersion-}" ]; then
  preBuildHooks+=(version-pretend-hook)
fi
