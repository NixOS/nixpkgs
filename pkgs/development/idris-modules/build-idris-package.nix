# Build an idris package
#
# args: Additional arguments to pass to mkDerivation. Generally should include at least
#       name and src.
{ stdenv, writeScript, makeSetupHook, idris, gmp }: args:
let setupfile = writeScript "setupfile" ''
  export IDRIS_LIBRARY_PATH=$PWD/idris-libs
  mkdir -p $IDRIS_LIBRARY_PATH

  # Library install path
  export IBCSUBDIR=$out/lib/${idris.name}
  mkdir -p $IBCSUBDIR

  addIdrisLibs () {
  if [ -d $1/lib/${idris.name} ]; then
  ln -svf $1/lib/${idris.name}/* $IDRIS_LIBRARY_PATH
  fi
  }

  # All run-time deps
  addEnvHooks "$targetOffset" addIdrisLibs
'';
in
stdenv.mkDerivation ({
  setupHook = setupfile;
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
    export IBCSUBDIR=$out/lib/${idris.name}
    ${idris}/bin/idris --install *.ipkg --ibcsubdir $IBCSUBDIR
  '';

  buildInputs = [ gmp ];
} // args)
