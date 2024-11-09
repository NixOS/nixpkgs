{ lib, buildDunePackage, reason, src }:

buildDunePackage {
  inherit src;

  pname = "utf8";
  version = "0.1.0-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  meta = {
    description = "Utf8 logic with minimal dependencies";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/utf8";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

