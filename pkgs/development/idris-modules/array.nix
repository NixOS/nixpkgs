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
    sha256 = "148dnyd664vnxi04zjsyjbs1y51dq0zz98005q9c042k4jcfpfjh";
  };

  meta = {
    description = "Primitive flat arrays containing Idris values";
    homepage = "https://github.com/idris-hackers/idris-array";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
