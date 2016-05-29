{ mkDerivation, aeson, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, containers, directory, edit-distance, fetchgit
, filemanip, filepath, HUnit, indents, mtl, optparse-applicative
, parsec, pretty, process, QuickCheck, quickcheck-io
, regex-applicative, split, stdenv, test-framework
, test-framework-hunit, test-framework-quickcheck2, text
, union-find, wl-pprint
}:
mkDerivation {
  pname = "elm-format";
  version = "0.3.1";
  src = fetchgit {
    url = "http://github.com/avh4/elm-format";
    sha256 = "04kl50kzvjf4i140dlhs6f9fd2wmk6cnvyfamx2xh8vbwbnwrkj4";
    rev = "0637f3772de2297d12ea35f5b66961e1d827552c";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson ansi-terminal ansi-wl-pprint base binary bytestring
    containers directory edit-distance filemanip filepath indents mtl
    optparse-applicative parsec pretty process regex-applicative split
    text
  ];
  testHaskellDepends = [
    aeson ansi-terminal base binary bytestring containers directory
    edit-distance filemanip filepath HUnit indents mtl parsec pretty
    process QuickCheck quickcheck-io regex-applicative split
    test-framework test-framework-hunit test-framework-quickcheck2 text
    union-find wl-pprint
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "A source code formatter for Elm";
  license = stdenv.lib.licenses.bsd3;
}
