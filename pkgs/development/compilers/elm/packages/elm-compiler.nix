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
    sha256 = "696413b69fa5e66f878ed189094be5f74dfaced42121c82ac88bbab1c2bb9861";
    rev = "cb1bad3b6ebaa02d5af47e9b98eab7d475a3a48d";
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
  description = "Values to help with elm-package, elm-make, and elm-lang.org.";
  license = stdenv.lib.licenses.bsd3;
}
