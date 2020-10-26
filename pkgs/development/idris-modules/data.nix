{ build-idris-package
, fetchFromGitHub
, contrib
, lib
}:
build-idris-package  {
  name = "data";
  version = "2018-03-19";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "jdevuyst";
    repo = "idris-data";
    rev = "105b78ac13235edc596287367a675d7cd04ce5d5";
    sha256 = "17wz4jddan39984qibx2x7nv2zkqznv0fpab20nrm4zgy17v77ii";
  };

  meta = {
    broken = true;
    description = "Functional data structures in Idris";
    homepage = "https://github.com/jdevuyst/idris-data";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
