{ stdenv, idris }: argf: let args = {
  preHook = ''
    mkdir idris-libs
    export IDRIS_LIBRARY_PATH=$PWD/idris-libs

    addIdrisLibs () {
      if [ -d $1/lib/${idris.name} ]; then
        ln -sv $1/lib/${idris.name}/* $IDRIS_LIBRARY_PATH
      fi
    }

    envHooks+=(addIdrisLibs)
  '';

  configurePhase = ''
    export TARGET=$out/lib/${idris.name}
  '';

  buildPhase = ''
    ${idris}/bin/idris --build *.ipkg
  '';

  doCheck = true;

  checkPhase = ''
    if grep -q test *.ipkg; then
      ${idris}/bin/idris --testpkg *.ipkg
    fi
  '';

  installPhase = ''
    ${idris}/bin/idris --install *.ipkg
  '';
}; in stdenv.mkDerivation (args // (argf args))
