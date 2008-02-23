# Support dir for isolating GHC
ghc_support=$TMPDIR/ghc-6.8-nix-support
mkdir -p $ghc_support

# Create isolated package config
packages_db=$ghc_support/package.conf
cp @out@/lib/ghc-*/package.conf $packages_db
chmod +w $packages_db

# Generate wrappers for GHC that use the isolated package config
makeWrapper() {
  wrapperName="$1"
  wrapper="$ghc_support/$wrapperName"
  shift #the other arguments are passed to the source app
  echo '#!'"$SHELL" > "$wrapper"
  echo "exec \"@out@/bin/$wrapperName\" $@" '"$@"' > "$wrapper"
  chmod +x "$wrapper"
}

makeWrapper "ghc"         "-no-user-package-conf -package-conf $packages_db"
makeWrapper "ghci"        "-no-user-package-conf -package-conf $packages_db"
makeWrapper "runghc"      "-no-user-package-conf -package-conf $packages_db"
makeWrapper "runhaskell"  "-no-user-package-conf -package-conf $packages_db"
makeWrapper "ghc-pkg"     "--global-conf $packages_db"

# Add wrappers to search path
export _PATH=$ghc_support:$_PATH

# Env hook to add packages to the package config
addLibToPackageConf ()
{
    local regscript=$1/nix-support/register-ghclib.sh
    if test -f $regscript; then
        local oldpath=$PATH
        export PATH=$ghc_support:$PATH
        sh $regscript $package_db
        export PATH=$oldpath
    fi
}

envHooks=(${envHooks[@]} addLibToPackageConf)
