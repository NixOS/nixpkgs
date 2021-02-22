{ mkDerivation, ansi-wl-pprint, avh4-lib, base, bimap, cmark
, containers, elm-format-lib, elm-format-test-lib, fetchgit, json
, lib, mtl, optparse-applicative, parsec, QuickCheck, quickcheck-io
, relude, tasty, tasty-hspec, tasty-hunit, tasty-quickcheck, text
}:
mkDerivation rec {
  pname = "elm-format";
  version = "0.8.5";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0bcjkcs1dy1csz0mpk7d4b5wf93fsj9p86x8fp42mb0pipdd0bh6";
    rev = "80f15d85ee71e1663c9b53903f2b5b2aa444a3be";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    ansi-wl-pprint avh4-lib base containers elm-format-lib json
    optparse-applicative relude text
  ];
  testHaskellDepends = [
    ansi-wl-pprint avh4-lib base bimap cmark containers elm-format-lib
    elm-format-test-lib json mtl optparse-applicative parsec QuickCheck
    quickcheck-io relude tasty tasty-hspec tasty-hunit tasty-quickcheck
    text
  ];
  doHaddock = false;
  homepage = "https://elm-lang.org";
  description = "A source code formatter for Elm";
  license = lib.licenses.bsd3;
  postPatch = ''
    mkdir -p ./generated
    cat <<EOHS > ./generated/Build_elm_format.hs
    module Build_elm_format where

    gitDescribe :: String
    gitDescribe = "${version}"
    EOHS
  '';
}
