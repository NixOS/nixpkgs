{ lib, buildDunePackage, fetchFromGitHub, lwt_ppx, ppx_cstruct, optint
, checkseum, diet, bitv, logs, lru, io-page, mirage-block }:

buildDunePackage rec {
  pname = "wodan";
  version = "unstable-2020-11-20";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "mirage";
    repo = pname;
    rev = "cc08fe25888051c207f1009bcd2d39f8c514484f";
    sha256 = "0186vlhnl8wcz2hmpn327n9a0bibnypmjy3w4nxq3yyglh6vj1im";
    fetchSubmodules = true;
  };

  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [
    lwt_ppx
    ppx_cstruct
    optint
    checkseum
    diet
    bitv
    /* nocrypto */
    logs
    lru
    io-page
    mirage-block
  ];

  meta = with lib; {
    broken = true; # nocrypto is no longer available in nixpkgs
    inherit (src.meta) homepage;
    description = "A flash-friendly, safe and flexible filesystem library";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
  };
}
