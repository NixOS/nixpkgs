{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "mapping";
  version = "2018-02-27";

  src = fetchFromGitHub {
    owner = "zaoqi";
    repo = "Mapping.idr";
    rev = "4f226933d4491b8fd09f9d9a7b862c0cc646b936";
    hash = "sha256-qjEytXLxsGu7DJ23VEgAfbzWemob1GLJ62BT8eVZc+o=";
  };

  meta = {
    description = "Idris mapping library";
    homepage = "https://github.com/zaoqi/Mapping.idr";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
