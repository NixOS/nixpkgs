{
  lib,
  buildDunePackage,
  reason,
  fp,
  src,
}:

buildDunePackage {
  inherit src;

  pname = "dir";
  version = "0.0.1-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    fp
  ];

  meta = {
    description = "Library that provides a consistent API for common system, user and application directories consistently on all platforms";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/dir";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
