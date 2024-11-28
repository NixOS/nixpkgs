{ lib, buildDunePackage, re, reason, pastel, src }:

buildDunePackage {
  inherit src;

  pname = "cli";
  version = "0.0.1-alpha-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  buildInputs = [
    re
    pastel
  ];

 meta = {
    downloadPage = "https://github.com/reasonml/reason-native";
    homepage = "https://reason-native.com/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
