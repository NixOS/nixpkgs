{ qcheck-core, reason, console, rely, fetchpatch, ... }:

{
  pname = "qcheck-rely";

  nativeBuildInputs = [
    reason
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/reasonml/reason-native/pull/269/commits/b42d66f5929a11739c13f849939007bf8610888b.patch";
      hash = "sha256-MMLl3eqF8xQZ2T+sIEuv2WpnGF6FZtatgH5fiF5hpP4=";
      includes = [
        "src/qcheck-rely/QCheckRely.re"
        "src/qcheck-rely/QCheckRely.rei"
      ];
    })
  ];

  propagatedBuildInputs = [
    qcheck-core
    console
    rely
  ];

  meta = {
    description = "A library containing custom Rely matchers allowing for easily using QCheck with Rely. QCheck is a 'QuickCheck inspired property-based testing for OCaml, and combinators to generate random values to run tests on'";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/qcheck-rely";
  };
}
