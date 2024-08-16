{ lib, buildDunePackage, qcheck-core, reason, console, rely, src }:

buildDunePackage {
  inherit src;

  pname = "qcheck-rely";
  version = "1.0.2-unstable-2024-05-07";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    qcheck-core
    console
    rely
  ];

  meta = {
    description = "Library containing custom Rely matchers allowing for easily using QCheck with Rely. QCheck is a 'QuickCheck inspired property-based testing for OCaml, and combinators to generate random values to run tests on'";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/qcheck-rely";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
