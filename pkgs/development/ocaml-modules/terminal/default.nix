{ lib, buildDunePackage, fetchurl, ocaml
, stdlib-shims, uutf, uucp
, alcotest, fmt
}:

buildDunePackage rec {
  pname = "terminal";
  version = "0.2.1";

  minimalOCamlVersion = "4.03";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/CraigFe/progress/releases/download/${version}/terminal-${version}.tbz";
    hash = "sha256:0vjqkvmpyi8kvmb4vrx3f0994rph8i9pvlrz1dyi126vlb2zbrvs";
  };

  propagatedBuildInputs = [ stdlib-shims uutf uucp ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest fmt ];

  meta = with lib; {
    description = "Basic utilities for interacting with terminals";
    homepage = "https://github.com/CraigFe/progress";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}

