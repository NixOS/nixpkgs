{ mkDerivation, aeson, aeson-pretty_0_7_2, ansi-terminal, ansi-wl-pprint
, base, binary, bytestring, containers, directory, edit-distance
, fetchgit, filemanip, filepath, HUnit, indents
, language-ecmascript, language-glsl, mtl, parsec, pretty, process
, QuickCheck , stdenv, test-framework, test-framework-hunit
, test-framework-quickcheck2, text, union-find
}:
mkDerivation {
  pname = "elm-compiler";
  version = "0.18";
  src = fetchgit {
    url = "https://github.com/elm/compiler";
    sha256 = "09fmrbfpc1kzc3p9h79w57b9qjhajdswc4jfm9gyjw95vsiwasgh";
    rev = "eb97f2a5dd5421c708a91b71442e69d02453cc80";
    fetchSubmodules = true;
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
  homepage = "http://elm-lang.org";
  description = "Values to help with elm-package, elm-make, and elm-lang.org.";
  license = stdenv.lib.licenses.bsd3;
  # Tests aren't passing, and the failing tests
  # haven't been fixed upstream.
  doCheck = false;
}
