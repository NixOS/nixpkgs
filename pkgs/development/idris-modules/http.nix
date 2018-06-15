{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, lightyear
, bytes
, lib
, idris
}:
build-idris-package  {
  name = "http";
  version = "2018-02-25";

  idrisDeps = [ prelude contrib lightyear bytes ];

  src = fetchFromGitHub {
    owner = "uwap";
    repo = "idris-http";
    rev = "dc4a31543f87c0bc44cbaa98192f0303cd8dd82e";
    sha256 = "1abrwi5ikymff4g7a0g5wskycvhpnn895z1z1bz9r71ks554ypl8";
  };

  meta = {
    description = "An HTTP library for idris";
    homepage = https://github.com/uwap/idris-http;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
