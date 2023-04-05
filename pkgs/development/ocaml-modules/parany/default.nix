{ lib, buildDunePackage, fetchFromGitHub, ocaml, cpu, domainslib }:

let params =
  if lib.versionAtLeast ocaml.version "5.00" then {
    version = "13.0.1";
    hash = "sha256-OYa0uLsDyzjmXZgWcYUxLhqco4Kp/icfDamNe3En5JQ=";
    propagatedBuildInputs = [ domainslib ];
  } else {
    version = "12.2.2";
    hash = "sha256-woZ4XJqqoRr/7mDurXYvTbSUUcLBEylzVYBQp1BAOqc=";
    propagatedBuildInputs = [ cpu ];
  }
; in

buildDunePackage rec {
  pname = "parany";
  inherit (params) version;

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = pname;
    rev = "v${version}";
    inherit (params) hash;
  };

  inherit (params) propagatedBuildInputs;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
