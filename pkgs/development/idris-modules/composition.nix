{
  build-idris-package,
  fetchFromGitHub,
  hezarfen,
  lib,
}:
build-idris-package {
  pname = "composition";
  version = "2017-11-12";

  idrisDeps = [ hezarfen ];

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "composition";
    rev = "8f05e8db750793a9992b315dc0a2c327b837ec8b";
    hash = "sha256-yKs5d8Yqi1DCMpJdjbDa2JKRbQkrbpXBi8OZ3n8nghQ=";
  };

  meta = {
    description = "Composition extras for Idris";
    homepage = "https://github.com/vmchale/composition";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
