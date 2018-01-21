{ build-idris-package
, lib
, fetchFromGitHub
, idris
, base
, bifunctors
, effects
, prelude
, wl-pprint
, lens
}:

build-idris-package {
  name = "optparse-2016-06-18";

  src = fetchFromGitHub {
    owner = "HuwCampbell";
    repo = "optparse-idris";
    rev = "ad0490ff0fa0e623d03cde1f49a4adffc6f9362f";
    sha256 = "0cyk1g7nrbphrrp8q3271lkc5sw9k15bzymqy5hxxxs7i1pj140x";
  };

  propagatedBuildInputs = [ prelude base effects lens wl-pprint bifunctors ];

  meta = {
    description = "Minimal port of optparse-applicative to idris";
    homepage = https://github.com/HuwCampbell/optparse-idris;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.siddharthist ];
    inherit (idris.meta) platforms;
  };
}
