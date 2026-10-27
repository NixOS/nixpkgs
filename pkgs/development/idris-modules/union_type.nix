{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "union_type";
  version = "2018-01-30";

  src = fetchFromGitHub {
    owner = "berewt";
    repo = "UnionType";
    rev = "f7693036237585fe324a815a96ad101d9659c689";
    hash = "sha256-R68cHu3QrDikgPBdgJ4tkQ/ApzJEovCkC14oOQeAwM8=";
  };

  meta = {
    description = "UnionType in Idris";
    homepage = "https://github.com/berewt/UnionType";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
