{ build-idris-package
, fetchFromGitHub
, prelude
, pruviloj
, lib
, idris
}:
build-idris-package  {
  name = "descncrunch";
  version = "2017-11-15";

  idrisDeps = [ prelude pruviloj ];

  src = fetchFromGitHub {
    owner = "ahmadsalim";
    repo = "desc-n-crunch";
    rev = "261d9718504b8f0572c4fe7ae407a0231779bcab";
    sha256 = "09fh334aga1z1hbw79507rdv7qsh0mqzb89lvpznn7vzi9zkl8fx";
  };

  meta = {
    description = "Descriptions, levitation, and reflecting the elaborator";
    homepage = https://github.com/ahmadsalim/desc-n-crunch;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
