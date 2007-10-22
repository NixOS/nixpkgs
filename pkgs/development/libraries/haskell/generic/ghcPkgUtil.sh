# mantainer: Marc Weber (marco-oweber@gmx.de)
#
# example usage: add ghcPkgUtil to buildInputs then somewhere in buildPhase:
#
#  createEmptyPackageDatabaseAndSetupHook
#  configure --with-package-db=$PACKAGE_DB
#  ... compile ghc library ...
# add your library to propagatedBuildInputs instead of buildInputs 
# in all depending libraries



# creates a setup hook
# adding the package database 
# nix-support/package.conf to GHC_PACKAGE_PATH
# if not already contained
setupHookRegisteringPackageDatabase(){
  ensureDir $out/nix-support;
  local pkgdb=$out/nix-support/package.conf
  cat >> $out/nix-support/setup-hook << EOF
    
    echo \$GHC_PACKAGE_PATH | grep -l $pkgdb &> /dev/null || \
      export GHC_PACKAGE_PATH=\$GHC_PACKAGE_PATH\${GHC_PACKAGE_PATH:+$PATH_DELIMITER}$pkgdb;
EOF
}

# create an empty package database in which the new library can be registered. 
createEmptyPackageDatabaseAndSetupHook(){
  ensureDir $out/nix-support;
  PACKAGE_DB=$out/nix-support/package.conf;
  echo '[]' > $PACKAGE_DB";
  setupHookRegisteringPackageDatabase
}
