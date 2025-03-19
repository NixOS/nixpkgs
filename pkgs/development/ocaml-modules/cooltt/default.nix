{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  bos,
  bwd,
  cmdliner,
  containers,
  ezjsonm,
  findlib,
  menhir,
  menhirLib,
  ppx_deriving,
  ppxlib,
  uuseg,
  uutf,
  yuujinchou,
  ounit2,
  qcheck,
  qcheck-core,
}:

let
  bantorra = buildDunePackage {
    pname = "bantorra";
    version = "unstable-2022-05-08";
    src = fetchFromGitHub {
      owner = "RedPRL";
      repo = "bantorra";
      rev = "d05c34295727dd06d0ac4416dc2e258732e8593d";
      hash = "sha256-s6lUTs3VRl6YhLAn3PO4aniANhFp8ytoTsFAgcOlee4=";
    };

    propagatedBuildInputs = [
      bos
      ezjsonm
      findlib
    ];

    meta = {
      description = "Extensible Library Management and Path Resolution";
      homepage = "https://github.com/RedPRL/bantorra";
      license = lib.licenses.asl20;
    };
  };
  kado = buildDunePackage rec {
    pname = "kado";
    version = "unstable-2023-10-03";
    src = fetchFromGitHub {
      owner = "RedPRL";
      repo = "kado";
      rev = "6b2e9ba2095e294e6e0fc6febc280d80c5799c2b";
      hash = "sha256-fP6Ade3mJeyOMjuDIvrW88m6E3jfb2z3L8ufgloz4Tc=";
    };

    propagatedBuildInputs = [ bwd ];

    doCheck = true;
    checkInputs = [ qcheck-core ];

    meta = {
      description = "Cofibrations in Cartecian Cubical Type Theory";
      homepage = "https://github.com/RedPRL/kado";
      license = lib.licenses.asl20;
    };
  };
in

buildDunePackage {
  pname = "cooltt";
  version = "unstable-2023-10-03";

  minimalOCamlVersion = "5.0";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "cooltt";
    rev = "a5eaf4db195b5166a7102d47d42724f59cf3de19";
    hash = "sha256-48bEf59rtPRrCRjab7+GxppjfR2c87HjQ+uKY2Bag0I=";
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
    description = "Cool implementation of normalization by evaluation (nbe) & elaboration for Cartesian cubical type theory";
    license = licenses.asl20;
    maintainers = with maintainers; [ moni ];
  };
}
