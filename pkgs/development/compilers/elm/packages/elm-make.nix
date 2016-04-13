{ mkDerivation, aeson, ansi-terminal, ansi-wl-pprint, base, binary
, blaze-html, blaze-markup, bytestring, containers, directory
, elm-compiler, elm-package, fetchgit, filepath, mtl
, optparse-applicative, stdenv, text, time
}:
mkDerivation {
  pname = "elm-make";
  version = "0.16";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-make";
    sha256 = "fc0a6ed08b236dfab43e9af73f8e83a3b88a155695a9671a2b291dc596a75116";
    rev = "54e0b33fea0cd72400ac6a3dec7643bf1b900741";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson ansi-terminal ansi-wl-pprint base binary blaze-html
    blaze-markup bytestring containers directory elm-compiler
    elm-package filepath mtl optparse-applicative text time
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "A build tool for Elm projects";
  license = stdenv.lib.licenses.bsd3;
}
