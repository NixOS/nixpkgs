{ lib, buildDunePackage, reason, re, pastel, src }:

buildDunePackage {
  inherit src;

  pname = "frame";
  version = "0.0.1-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    pastel
    re
  ];

  meta = {
    description = "Reason Native text layout library";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/frame";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
