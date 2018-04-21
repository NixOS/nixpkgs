{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}:
build-idris-package  {
  name = "union_type";
  version = "2018-01-30";

  idrisDeps = [ prelude base ];

  src = fetchFromGitHub {
    owner = "berewt";
    repo = "UnionType";
    rev = "f7693036237585fe324a815a96ad101d9659c689";
    sha256 = "1ky0h03kja2y1fjg18j46akw03wi5ng80pghh2j3ib6hxlg1rbs7";
  };

  meta = {
    description = "UnionType in Idris";
    homepage = https://github.com/berewt/UnionType;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
