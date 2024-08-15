{ lib, buildDunePackage, reason, src }:

buildDunePackage {
  inherit src;

  pname = "unicode";
  version = "0.0.0-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  meta = {
    description = "Easy to use and well documented Unicode symbols";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/unicode";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
