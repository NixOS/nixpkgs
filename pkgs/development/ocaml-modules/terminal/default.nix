{ lib, buildDunePackage, fetchurl, ocaml
, stdlib-shims, uutf, uucp
, alcotest, fmt
}:

buildDunePackage rec {
  pname = "terminal";
  version = "0.4.0";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/CraigFe/progress/releases/download/${version}/progress-${version}.tbz";
    hash = "sha256-i+RJVTN5uy3F6LeYBcgER2kKA9yj6a7pWf7PRtgnj7c=";
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

