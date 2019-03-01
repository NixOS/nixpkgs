# Adds hooks to run for each dependency to the generic-builder.nix. There are two types of dependencies that Cabal needs to know about.

# - Haskell dependencies have a $package.conf.d directory that stores
#   all necessary information for using the package as a dependency. -

# - External dependencies don’t have a package.conf.d directory. Cabal
#   needs the --extra-include-dirs, --extra-lib-dirs, and
#   --extra-framework-dirs to detect them. We only want to set
#   --extra-lib-dirs when we know that there are actual libraries
#   available and not meta information like cmake or pkgconfig data.

setupPackageConfDir="$TMPDIR/setup-package.conf.d"
mkdir -p $setupPackageConfDir

packageConfDir="$TMPDIR/package.conf.d"
mkdir -p $packageConfDir

# We build the Setup.hs on the *build* machine, and as such should
# only add dependencies for the build machine.

addCabalPkgDb() {
  if [ -n "$(echo $1/lib/*/package.conf.d)" ]; then
     cp -f $1/lib/*/package.conf.d/*.conf "$packageConfDir"
  fi
}

addCabalSetupPkgDb() {
  if [ -n "$(echo $1/lib/*/package.conf.d)" ]; then
     cp -f $1/lib/*/package.conf.d/*.conf "$setupPackageConfDir"
  fi
}

addCabalConfigureFlags() {
  if [ -z "$(echo $1/lib/*/package.conf.d)" ]; then
    if [ -d "$1/include" ]; then
      configureFlags+=" --extra-include-dirs=$1/include"
    fi
    if [ -n "$(echo $1/lib/lib*)" ]; then
      configureFlags+=" --extra-lib-dirs=$1/lib"
    fi
    if [ -d "$1/Library/Frameworks" ]; then
      configureFlags+=" --extra-framework-dirs=$1/Library/Frameworks"
    fi
  fi
}

addEnvHooks "$hostOffset" addCabalSetupPkgDb
addEnvHooks "$targetOffset" addCabalPkgDb
addEnvHooks "$targetOffset" addCabalConfigureFlags
