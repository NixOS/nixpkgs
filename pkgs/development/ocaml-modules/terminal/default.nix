{
  lib,
  buildDunePackage,
  fetchurl,
  ocaml,
  stdlib-shims,
  uutf,
  uucp,
  alcotest,
  fmt,
}:

buildDunePackage rec {
  pname = "terminal";
  version = "0.5.0";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/CraigFe/progress/releases/download/${version}/progress-${version}.tbz";
    hash = "sha256-f4fwWXNjkoxFuoWa5aFDD2qjwp4lH/GlPPeG7Q4EWWE=";
  };

  propagatedBuildInputs = [
    stdlib-shims
    uutf
    uucp
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [
    alcotest
    fmt
  ];

  meta = with lib; {
    description = "Basic utilities for interacting with terminals";
    homepage = "https://github.com/CraigFe/progress";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
