{
  mkDerivation,
  aeson,
  ansi-wl-pprint,
  avh4-lib,
  base,
  bytestring,
  elm-format-lib,
  elm-format-test-lib,
  fetchgit,
  hspec,
  lib,
  optparse-applicative,
  QuickCheck,
  quickcheck-io,
  relude,
  tasty,
  tasty-hspec,
  tasty-hunit,
  tasty-quickcheck,
  text,
}:
mkDerivation {
  pname = "elm-format";
  version = "0.8.8";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "13i1wgva6p9zsx1a7sfb3skc0rv187isb920chkhljyh48c12k8l";
    rev = "d07fddc8c0eef412dba07be4ab8768d6abcca796";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson
    ansi-wl-pprint
    avh4-lib
    base
    bytestring
    elm-format-lib
    optparse-applicative
    relude
    text
  ];
  testHaskellDepends = [
    aeson
    ansi-wl-pprint
    avh4-lib
    base
    bytestring
    elm-format-lib
    elm-format-test-lib
    hspec
    optparse-applicative
    QuickCheck
    quickcheck-io
    relude
    tasty
    tasty-hspec
    tasty-hunit
    tasty-quickcheck
    text
  ];
  doHaddock = false;
  homepage = "https://elm-lang.org";
  description = "A source code formatter for Elm";
  license = lib.licenses.bsd3;
  mainProgram = "elm-format";
}
