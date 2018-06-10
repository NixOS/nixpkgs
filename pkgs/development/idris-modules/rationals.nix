{ curl
, build-idris-package
, fetchFromGitHub
, prelude
, contrib
, lib
, idris
}:
build-idris-package {
  name = "rationals";
  version = "2017-04-29";

  idrisDeps = [ prelude contrib ];

  src = fetchFromGitHub {
    owner = "mcgordonite";
    repo = "idris-binary-rationals";
    rev = "0d7010b267662d89e76e2cc8b27fd95ecca009b8";
    sha256 = "0fc93n4pyqyrjxrspnr3vjzc09m78ni1ardq1vx9g40vmvl0n49s";
  };

  meta = {
    description = "An idris rational number type built from paths in the Stern Brocot tree";
    homepage = https://github.com/mcgordonite/idris-binary-rationals;
    inherit (idris.meta) platforms;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
