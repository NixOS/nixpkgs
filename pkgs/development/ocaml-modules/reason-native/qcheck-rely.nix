{ qcheck-core, reason, console, rely, ... }:

{
  pname = "qcheck-rely";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    qcheck-core
    console
    rely
  ];

  meta = {
    description = "A library containing custom Rely matchers allowing for easily using QCheck with Rely. QCheck is a 'QuickCheck inspired property-based testing for OCaml, and combinators to generate random values to run tests on'";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/qcheck-rely";
    broken = true;
  };
}
