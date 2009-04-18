# Create isolated package config
packages_db=$TMPDIR/.package.conf
cp @ghc@/lib/ghc-*/package.conf $packages_db
chmod u+w $packages_db

export GHC_PACKAGE_PATH=$packages_db

# Env hook to add packages to the package config
addLibToPackageConf () {
    local fn
    shopt -s nullglob
    for fn in $1/lib/ghc-pkgs/ghc-@ghcVersion@/*.conf; do
        @ghc@/bin/ghc-pkg register $fn
    done
}

envHooks=(${envHooks[@]} addLibToPackageConf)
