{ build-idris-package
, fetchFromGitHub
, prelude
, effects
, lib
, idris
}:

build-idris-package  {
  name = "test";
  version = "2017-03-30";

  idrisDeps = [ prelude effects ];

  src = fetchFromGitHub {
    owner = "jfdm";
    repo = "idris-testing";
    rev = "604d56f77054931b21975198be669e22427b1f52";
    sha256 = "1pmyhs3jx6wd0pzjd3igfxb9zjs8pqmk4ah352bxjrqdnhqwrl51";
  };


  doCheck = false;

  meta = {
    description = "Testing Utilities for Idris programs";
    homepage = https://github.com/jfdm/idris-testing;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
