# shellcheck shell=bash
#
# This uses the install path convention established by nixpkgs maintainers
# for all beam packages. Changing this will break compatibility with other
# builder functions like buildRebar3 and buildErlangMk.

beamModuleInstallHook() {
  echo "Executing beamModuleInstallHook"

  mkdir -p "$out/lib/erlang/lib/${beamModuleName}-${version}"

  # default to rebar3
  local fromDir=(./{ebin,priv,include})

  # replace if mix project
  if [ -n "$MIX_BUILD_PREFIX" ]; then
    fromDir=(_build/{$MIX_BUILD_PREFIX,shared}/lib/"${beamModuleName}"/{src,ebin,priv,include})
  fi

  for reldir in "${fromDir[@]}"; do
    if test -d "$reldir"; then
      # Some builds produce symlinks (eg: phoenix priv directory). They must
      # be followed with -H flag.
      cp -vHrt "$out/lib/erlang/lib/${beamModuleName}-${version}" "$reldir"
    fi
  done

  echo "Finished beamModuleInstallHook"
}

if [ -z "${dontBeamModuleInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=beamModuleInstallHook
fi
