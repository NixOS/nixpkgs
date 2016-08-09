{ mkDerivation, aeson, ansi-terminal, ansi-wl-pprint, base, binary
, blaze-html, blaze-markup, bytestring, containers, directory
, elm-compiler, elm-package, fetchgit, filepath, mtl
, optparse-applicative, raw-strings-qq, stdenv, text, time
}:
mkDerivation {
  pname = "elm-make";
  version = "0.17.1";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-make";
    sha256 = "0k9w5gl48lhhr3n2iflf0vkb3w6al0xcbglgiw4fq1ssz3aa7ijw";
    rev = "0a0a1f52ab04e2d68d60a5798722e1de30b47335";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson ansi-terminal ansi-wl-pprint base binary blaze-html
    blaze-markup bytestring containers directory elm-compiler
    elm-package filepath mtl optparse-applicative raw-strings-qq text
    time
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "A build tool for Elm projects";
  license = stdenv.lib.licenses.bsd3;
}
