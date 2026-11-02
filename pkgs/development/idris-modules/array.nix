{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "array";
  version = "2016-10-14";

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "idris-array";
    rev = "eb5c034d3c65b5cf465bd0715e65859b8f69bf15";
    hash = "sha256-ULrrmCRTEMASLgCg9D/ALRQf9JJey09A7HYTY5q3DZE=";
  };

  meta = {
    description = "Primitive flat arrays containing Idris values";
    homepage = "https://github.com/idris-hackers/idris-array";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
