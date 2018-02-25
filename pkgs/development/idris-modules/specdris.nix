{ build-idris-package
, fetchgit
, prelude
, base
, effects
, lib
, idris
}:

let
  versionString = "0.3.0";
in
build-idris-package {
  name = "specdris";
  version = versionString;

  src = fetchgit {
    url = "https://github.com/pheymann/specdris";
    rev = "v" + versionString;
    sha256 = "1gc717xf4i7z75aqazy5wqm7b1dqfyx5pprdypxz1h3980m67fsa";
  };

  idrisDeps = [ prelude base effects idris ];

  # The tests attribute is very strange as the tests are a different ipkg
  doCheck = false;

  meta = {
    maintainers = [ lib.maintainers.brandondyck ];
	description = "A testing library for Idris";
    homepage = https://github.com/pheymann/specdris;
    license = lib.licenses.mit;
  };
}
