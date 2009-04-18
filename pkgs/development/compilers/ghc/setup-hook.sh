# Create isolated package config
packages_db=$TMPDIR/.package.conf
cp @ghc@/lib/ghc-*/package.conf $packages_db
chmod u+w $packages_db

export GHC_PACKAGE_PATH=$packages_db

# Env hook to add packages to the package config
addLibToPackageConf () {
    local confFile=$1/nix-support/ghc-package.conf
    if test -f $confFile; then
        @ghc@/bin/ghc-pkg register $confFile
    fi
}

envHooks=(${envHooks[@]} addLibToPackageConf)
