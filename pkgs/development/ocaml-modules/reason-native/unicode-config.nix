{
  lib,
  buildDunePackage,
  reason,
  src,
}:

buildDunePackage {
  inherit src;

  pname = "unicode-config";
  version = "0.0.0-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  meta = {
    description = "Configuration used to generate the @reason-native/unicode library";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/unicode-config";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
