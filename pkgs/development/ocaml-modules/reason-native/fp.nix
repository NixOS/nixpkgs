{ lib, buildDunePackage, reason, src }:

buildDunePackage {
  inherit src;

  pname = "fp";
  version = "0.0.1-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  meta = {
    description = "Library for creating and operating on file paths consistently on multiple platforms";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/fp";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
