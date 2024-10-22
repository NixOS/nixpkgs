{ lib, buildDunePackage, atdgen, junit, re, reason, pastel, rely, src }:

buildDunePackage {
  inherit src;

  pname = "rely-junit-reporter";
  version = "1.0.0-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  buildInputs = [
    atdgen
  ];

  propagatedBuildInputs = [
    junit
    re
    pastel
    rely
  ];

  meta = {
    description = "Tool providing JUnit Reporter for Rely Testing Framework";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/rely-junit-reporter";
    homepage = "https://reason-native.com/docs/rely/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
