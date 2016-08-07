{ mkDerivation, aeson, aeson-pretty_0_7_2, ansi-terminal, ansi-wl-pprint
, base, binary, bytestring, containers, directory, edit-distance
, fetchgit, filemanip, filepath, HUnit, indents
, language-ecmascript, language-glsl, mtl, parsec, pretty, process
, QuickCheck, stdenv, test-framework, test-framework-hunit
, test-framework-quickcheck2, text, union-find
}:
mkDerivation {
  pname = "elm-compiler";
  version = "0.17.1";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-compiler";
    sha256 = "17y0jlii81mnjywknblcv1nfja51slmwrhz9x8w144b0sblcj0if";
    rev = "e44deafaf9cbf3749484070f267f03a368711adb";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty_0_7_2 ansi-terminal ansi-wl-pprint base binary
    bytestring containers directory edit-distance filepath indents
    language-ecmascript language-glsl mtl parsec pretty process text
    union-find
  ];
  executableHaskellDepends = [
    aeson base binary directory filepath process text
  ];
  testHaskellDepends = [
    aeson aeson-pretty_0_7_2 ansi-terminal ansi-wl-pprint base binary
    bytestring containers directory edit-distance filemanip filepath
    HUnit indents language-ecmascript language-glsl mtl parsec pretty
    process QuickCheck test-framework test-framework-hunit
    test-framework-quickcheck2 text union-find
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "Values to help with elm-package, elm-make, and elm-lang.org.";
  license = stdenv.lib.licenses.bsd3;
}
