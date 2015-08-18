{ mkDerivation, aeson, aeson-pretty, ansi-terminal, base, binary
, blaze-html, blaze-markup, bytestring, cmdargs, containers
, directory, edit-distance, fetchgit, filemanip, filepath, HUnit
, indents, language-ecmascript, language-glsl, mtl, parsec, pretty
, process, QuickCheck, stdenv, test-framework, test-framework-hunit
, test-framework-quickcheck2, text, transformers, union-find
, unordered-containers
}:
mkDerivation {
  pname = "elm-compiler";
  version = "0.15.1";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-compiler";
    sha256 = "379a38db4f240ab206a2bbedc49d4768d7cf6fdf497b2d25dea71fca1d58efaa";
    rev = "7fbdee067b494c0298d07c944629aaa5d3fa82f5";
  };
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aeson-pretty ansi-terminal base binary blaze-html
    blaze-markup bytestring cmdargs containers directory edit-distance
    filepath indents language-ecmascript language-glsl mtl parsec
    pretty process text transformers union-find unordered-containers
  ];
  testDepends = [
    aeson aeson-pretty ansi-terminal base binary blaze-html
    blaze-markup bytestring cmdargs containers directory edit-distance
    filemanip filepath HUnit indents language-ecmascript language-glsl
    mtl parsec pretty process QuickCheck test-framework
    test-framework-hunit test-framework-quickcheck2 text transformers
    union-find
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "Values to help with elm-package, elm-make, and elm-lang.org.";
  license = stdenv.lib.licenses.bsd3;
}
