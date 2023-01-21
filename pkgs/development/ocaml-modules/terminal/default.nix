{ lib, buildDunePackage, fetchurl, ocaml
, stdlib-shims, uutf, uucp
, alcotest, fmt
}:

buildDunePackage rec {
  pname = "terminal";
  version = "0.2.1";

  minimalOCamlVersion = "4.03";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/CraigFe/progress/releases/download/${version}/terminal-${version}.tbz";
    sha256 = "sha256:0vjqkvmpyi8kvmb4vrx3f0994rph8i9pvlrz1dyi126vlb2zbrvs";
  };

  propagatedBuildInputs = [ stdlib-shims uutf uucp ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  nativeCheckInputs = [ alcotest fmt ];

  meta = with lib; {
    description = "Basic utilities for interacting with terminals";
    homepage = "https://github.com/CraigFe/progress";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}

