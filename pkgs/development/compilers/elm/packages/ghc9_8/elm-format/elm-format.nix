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
mkDerivation rec {
  pname = "elm-format";
  version = "0.8.8";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0klhnfvy1l6mck46qwk6pp4d66cvj0m5w91ylghdcr4fb6ka1gp0";
    rev = "b06902f1e450f8be1e7b318caab7ccb1950893fa";
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
  postPatch = ''
    mkdir -p ./generated
    cat <<EOHS > ./generated/Build_elm_format.hs
    module Build_elm_format where

    gitDescribe :: String
    gitDescribe = "${version}"
    EOHS
  '';
}
