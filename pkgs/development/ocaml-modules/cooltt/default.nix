{ lib
, fetchFromGitHub
, fetchurl
, buildDunePackage
, bwd
, cmdliner
, containers
, ezjsonm
, menhir
, menhirLib
, ppx_deriving
, ppxlib
, uuseg
, uutf
, yuujinchou
, ounit2
, qcheck
}:

let
  bantorra = buildDunePackage rec {
    pname = "bantorra";
    version = "unstable-2022-04-20";
    src = fetchFromGitHub {
      owner = "RedPRL";
      repo = "bantorra";
      rev = "1e78633d9a2ef7104552a24585bb8bea36d4117b";
      sha256 = "sha256:15v1cggm7awp11iwl3lzpaar91jzivhdxggp5mr48gd28kfipzk2";
    };

    propagatedBuildInputs = [ ezjsonm ];

    meta = {
      description = "Extensible Library Management and Path Resolution";
      homepage = "https://github.com/RedPRL/bantorra";
      license = lib.licenses.asl20;
    };
  };
  kado = buildDunePackage rec {
    pname = "kado";
    version = "unstable-2022-04-30";
    src = fetchFromGitHub {
      owner = "RedPRL";
      repo = "kado";
      rev = "8dce50e7d759d482b82565090e550d3860d64729";
      sha256 = "sha256:1xb754fha4s0bgjfqjxzqljvalmkfdwdn5y4ycsp51wiah235bsy";
    };

    propagatedBuildInputs = [ bwd ];

    doCheck = true;

    meta = {
      description = "Cofibrations in Cartecian Cubical Type Theory";
      homepage = "https://github.com/RedPRL/kado";
      license = lib.licenses.asl20;
    };
  };
in

buildDunePackage {
  pname = "cooltt";
  version = "unstable-2022-04-28";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "cooltt";
    rev = "88511e10cb9e17286f585882dee334f3d8ace47c";
    sha256 = "sha256:1n9bh86r2n9s3mm7ayfzwjbnjqcphpsf8yqnf4whd3yi930sqisw";
  };

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    cmdliner
    ppxlib
  ];

  propagatedBuildInputs = [
    bantorra
    bwd
    ezjsonm
    kado
    menhirLib
    ppx_deriving
    uuseg
    uutf
    yuujinchou
    containers
  ];

  checkInputs = [
    ounit2
    qcheck
  ];

  meta = with lib; {
    homepage = "https://github.com/RedPRL/cooltt";
    description = "A cool implementation of normalization by evaluation (nbe) & elaboration for Cartesian cubical type theory";
    license = licenses.asl20;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
