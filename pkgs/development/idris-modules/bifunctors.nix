{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  pname = "bifunctors";
  version = "2017-02-07";

  src = fetchFromGitHub {
    owner = "japesinator";
    repo = "Idris-Bifunctors";
    rev = "be7b8bde88331ad3af87e5c0a23fc0f3d52f3868";
    sha256 = "0cfp58lhm2g0g1vrpb0mh71qb44n2yvg5sil9ndyf2sqd5ria6yq";
  };

  meta = {
    description = "A small bifunctor library for idris";
    homepage = "https://github.com/japesinator/Idris-Bifunctors";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
