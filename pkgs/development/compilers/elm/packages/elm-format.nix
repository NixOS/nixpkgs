{ mkDerivation, aeson, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, containers, directory, edit-distance, fetchgit
, filemanip, filepath, HUnit, indents, mtl, optparse-applicative
, parsec, pretty, process, QuickCheck, quickcheck-io
, regex-applicative, split, stdenv, tasty, tasty-golden
, tasty-hunit, tasty-quickcheck, text, union-find, wl-pprint
}:
mkDerivation {
  pname = "elm-format";
  version = "0.5.2";
  src = fetchgit {
    url = "http://github.com/avh4/elm-format";
    sha256 = "0lman7h6wr75y90javcc4y1scvwgv125gqqaqvfrd5xrfmm43gg8";
    rev = "e452ed9342620e7bb0bc822983b96411d57143ef";
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
    aeson ansi-terminal ansi-wl-pprint base binary bytestring
    containers directory edit-distance filemanip filepath HUnit indents
    mtl optparse-applicative parsec pretty process QuickCheck
    quickcheck-io regex-applicative split tasty tasty-golden
    tasty-hunit tasty-quickcheck text union-find wl-pprint
  ];
  jailbreak = true;
  postInstall = ''
    ln -s $out/bin/elm-format-0.18 $out/bin/elm-format
  '';
  homepage = "http://elm-lang.org";
  description = "A source code formatter for Elm";
  license = stdenv.lib.licenses.bsd3;
}
