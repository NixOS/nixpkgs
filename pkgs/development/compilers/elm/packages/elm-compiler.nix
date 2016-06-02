{ mkDerivation, aeson, aeson-pretty, ansi-terminal, ansi-wl-pprint
, base, binary, bytestring, containers, directory, edit-distance
, fetchgit, filemanip, filepath, HUnit, indents
, language-ecmascript, language-glsl, mtl, parsec, pretty, process
, QuickCheck, stdenv, test-framework, test-framework-hunit
, test-framework-quickcheck2, text, union-find, wl-pprint
}:
mkDerivation {
  pname = "elm-compiler";
  version = "0.17";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-compiler";
    sha256 = "1vx4jp20nj4s41zsqnwyh80dvg7b7kd9fh6agl99v1xx9d3i6ws1";
    rev = "c9c7e72c424a13255f8ee84c719f7ef48b689c1a";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal ansi-wl-pprint base binary
    bytestring containers directory edit-distance filepath indents
    language-ecmascript language-glsl mtl parsec pretty process text
    union-find wl-pprint
  ];
  executableHaskellDepends = [
    aeson base binary directory filepath process text
  ];
  testHaskellDepends = [
    aeson aeson-pretty ansi-terminal ansi-wl-pprint base binary
    bytestring containers directory edit-distance filemanip filepath
    HUnit indents language-ecmascript language-glsl mtl parsec pretty
    process QuickCheck test-framework test-framework-hunit
    test-framework-quickcheck2 text union-find wl-pprint
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "Values to help with elm-package, elm-make, and elm-lang.org";
  license = stdenv.lib.licenses.bsd3;
}
