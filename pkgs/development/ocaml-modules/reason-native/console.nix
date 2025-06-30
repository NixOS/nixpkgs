{
  lib,
  buildDunePackage,
  callPackage,
  reason,
  console,
  src,
}:

buildDunePackage {
  inherit src;

  pname = "console";
  version = "0.1.0-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  passthru.tests = {
    console = callPackage ./tests/console { };
  };

  meta = {
    description = "Library providing a web-influenced polymorphic console API for native Console.log(anything) with runtime printing";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/console";
    homepage = "https://reason-native.com/docs/console/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
