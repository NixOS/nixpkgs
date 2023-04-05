{ buildDunePackage, callPackage, reason, console, ... }:

{
  pname = "console";

  nativeBuildInputs = [
    reason
  ];

  passthru.tests = {
    console = callPackage ./tests/console {
      inherit buildDunePackage reason console;
    };
  };

  meta = {
    description = "A library providing a web-influenced polymorphic console API for native Console.log(anything) with runtime printing";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/console";
    homepage = "https://reason-native.com/docs/console/";
  };
}
