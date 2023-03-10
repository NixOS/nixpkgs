{ mkDerivation, aeson, ansi-wl-pprint, avh4-lib, base, bimap
, bytestring, containers, elm-format-lib, elm-format-test-lib
, fetchgit, hspec, lib, mtl, optparse-applicative, QuickCheck
, quickcheck-io, relude, tasty, tasty-hspec, tasty-hunit
, tasty-quickcheck, text
}:
mkDerivation rec {
  pname = "elm-format";
  version = "0.8.6";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "1aiq3mv2ycv6bal5hnz6k33bzmnnidzxxs5b6z9y6lvmr0lbf3j4";
    rev = "7e80dd48dd9b30994e43f4804b2ea7118664e8e0";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson ansi-wl-pprint avh4-lib base bytestring containers
    elm-format-lib optparse-applicative relude text
  ];
  testHaskellDepends = [
    aeson ansi-wl-pprint avh4-lib base bimap bytestring containers
    elm-format-lib elm-format-test-lib hspec mtl optparse-applicative
    QuickCheck quickcheck-io relude tasty tasty-hspec tasty-hunit
    tasty-quickcheck text
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
