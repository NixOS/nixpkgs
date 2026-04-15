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
    sha256 = "1skkb7jz2lv0xg4n5m0vd9xddg3x01459dwx1jxnpc7ifask4cda";
  };

  meta = {
    description = "Idris mapping library";
    homepage = "https://github.com/zaoqi/Mapping.idr";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
