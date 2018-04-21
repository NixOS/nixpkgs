{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}:
build-idris-package  {
  name = "bifunctors";
  version = "2017-02-07";

  idrisDeps = [ prelude base ];

  src = fetchFromGitHub {
    owner = "japesinator";
    repo = "Idris-Bifunctors";
    rev = "be7b8bde88331ad3af87e5c0a23fc0f3d52f3868";
    sha256 = "0cfp58lhm2g0g1vrpb0mh71qb44n2yvg5sil9ndyf2sqd5ria6yq";
  };

  postUnpack = ''
    rm source/test.ipkg
  '';

  meta = {
    description = "A small bifunctor library for idris";
    homepage = https://github.com/japesinator/Idris-Bifunctors;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
