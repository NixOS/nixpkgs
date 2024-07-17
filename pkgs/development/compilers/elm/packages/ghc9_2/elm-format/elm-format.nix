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
  version = "0.8.7";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "04l1bn4w8q3ifd6mc4mfrqxfbihmqnpfjdn6gr0x2jqcasjbk0bi";
    rev = "b5cca4c26b473dab06e5d73b98148637e4770d45";
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
  homepage = "https://elm-lang.org";
  description = "A source code formatter for Elm";
  license = lib.licenses.bsd3;
  mainProgram = "elm-format";
}
