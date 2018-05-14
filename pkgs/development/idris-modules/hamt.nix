{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, effects
, lib
, idris
}:
build-idris-package  {
  name = "idris-hamt";
  version = "2016-11-15";

  idrisDeps = [ prelude contrib effects ];

  src = fetchFromGitHub {
    owner = "bamboo";
    repo = "idris-hamt";
    rev = "e70f3eedddb5ccafea8e386762b8421ba63c495a";
    sha256 = "0m2yjr20dxkfmn3nzc68l6vh0rdaw6b637yijwl4c83b5xiac1mi";
  };

  meta = {
    description = "Idris Hash Array Mapped Trie";
    homepage = https://github.com/bamboo/idris-hamt;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
