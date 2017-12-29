{ build-idris-package
, fetchgit
, prelude
, base
, effects
, lib
, idris
}:

let
  date = "2017-11-11";
in
build-idris-package {
  name = "specdris-${date}";

  src = fetchgit {
    url = "https://github.com/pheymann/specdris";
    rev = "88b80334b8e0b6601324e2410772d35022fc8eaa";
    sha256 = "4813c4be1d4c3dd1dad35964b085f83cf9fb44b16824257c72b468d4bafd0e4f";
  };

  propagatedBuildInputs = [ prelude base effects ];

  buildPhase = ''
    ${idris}/bin/idris --build specdris.ipkg
  '';

  checkPhase = ''
      cd test/
      ${idris}/bin/idris --testpkg test.ipkg
      cd ../
    '';

  installPhase = ''
    ${idris}/bin/idris --install specdris.ipkg --ibcsubdir $IBCSUBDIR
  '';

  meta = {
    description = "A testing library for Idris";
    homepage = https://github.com/pheymann/specdris;
    license = lib.licenses.mit;
  };
}
