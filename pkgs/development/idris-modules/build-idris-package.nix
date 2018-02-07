# Build an idris package
#
# args: Additional arguments to pass to mkDerivation. Generally should include at least
#       name and src.
{ stdenv, idris, gmp }: args: stdenv.mkDerivation ({
  buildPhase = ''
    idris --build *.ipkg
  '';

  doCheck = true;

  checkPhase = ''
    if grep -q test *.ipkg; then
      idris --testpkg *.ipkg
    fi
  '';

  installPhase = ''
    idris --install *.ipkg --ibcsubdir $IBCSUBDIR
  '';

  buildInputs = [ gmp idris ];
} // args)
