{ lib, buildDunePackage, reason, re, src }:

buildDunePackage {
  inherit src;

  pname = "pastel";
  version = "0.3.0-unstable-2024-05-07";

  minimalOCamlVersion = "4.05";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    re
  ];

  meta = {
    description = "Text formatting library that harnesses Reason JSX to provide intuitive terminal output. Like React but for CLI";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/pastel";
    homepage = "https://reason-native.com/docs/pastel/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
