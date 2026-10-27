{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "refined";
  version = "2017-12-28";

  ipkgName = "idris-refined";

  src = fetchFromGitHub {
    owner = "janschultecom";
    repo = "idris-refined";
    rev = "e21cdef16106a77b42d193806c1749ba6448a128";
    hash = "sha256-0B8C3Wl6dzP+iPZgxYIDD/TdE2Vok5JopV/cUJibp6o=";
  };

  meta = {
    description = "Port of Scala/Haskell Refined library to Idris";
    homepage = "https://github.com/janschultecom/idris-refined";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
