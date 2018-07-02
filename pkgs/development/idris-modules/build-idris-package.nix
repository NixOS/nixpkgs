# Build an idris package
{ stdenv, idrisPackages, gmp }:
  { idrisDeps ? []
  , name
  , version
  , src
  , meta
  , extraBuildInputs ? []
  , postUnpack ? ""
  , doCheck ? true
  }:
let
  idris-with-packages = idrisPackages.with-packages idrisDeps;
in
stdenv.mkDerivation ({

  name = "${name}-${version}";

  inherit postUnpack src doCheck meta;


  # Some packages use the style
  # opts = -i ../../path/to/package
  # rather than the declarative pkgs attribute so we have to rewrite the path.
  postPatch = ''
    sed -i *.ipkg -e "/^opts/ s|-i \\.\\./|-i ${idris-with-packages}/libs/|g"
  '';

  buildPhase = ''
    ${idris-with-packages}/bin/idris --build *.ipkg
  '';

  checkPhase = ''
    if grep -q test *.ipkg; then
      ${idris-with-packages}/bin/idris --testpkg *.ipkg
    fi
  '';

  installPhase = ''
    ${idris-with-packages}/bin/idris --install *.ipkg --ibcsubdir $out/libs
    IDRIS_DOC_PATH=$out/doc ${idris-with-packages}/bin/idris --installdoc *.ipkg
  '';

  buildInputs = [ gmp ] ++ extraBuildInputs;

  propagatedBuildInputs = idrisDeps;
})
