{
  lib,
  buildDunePackage,
  fp,
  reason,
  src,
}:

buildDunePackage {
  inherit src;

  pname = "fs";
  version = "0.0.2-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    fp
  ];

  meta = {
    description = "Reason Native file system API";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/fs";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
