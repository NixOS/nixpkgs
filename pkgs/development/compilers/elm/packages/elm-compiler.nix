{ mkDerivation, aeson, aeson-pretty, ansi-terminal, ansi-wl-pprint
, base, binary, bytestring, containers, directory, edit-distance
, fetchgit, filemanip, filepath, HUnit, indents
, language-ecmascript, language-glsl, mtl, parsec, pretty, process
, QuickCheck, stdenv, test-framework, test-framework-hunit
, test-framework-quickcheck2, text, union-find, wl-pprint
}:
mkDerivation {
  pname = "elm-compiler";
  version = "0.16";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-compiler";
    sha256 = "b3bcdca469716f3a4195469549a9e9bc53a6030aff132ec620b9c93958a5ffe6";
    rev = "df86c1c9b3cf06de3ccb78f26b4d2fac0129ce5a";
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
