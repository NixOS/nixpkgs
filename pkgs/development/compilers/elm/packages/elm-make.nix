{ mkDerivation, aeson, ansi-terminal, ansi-wl-pprint, base, binary
, blaze-html, blaze-markup, bytestring, containers, directory
, elm-compiler, elm-package, fetchgit, filepath, mtl
, optparse-applicative, raw-strings-qq, stdenv, text, time
}:
mkDerivation {
  pname = "elm-make";
  version = "0.18";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-make";
    sha256 = "1yq4w4yqignlc2si5ns53pmz0a99gix5d2qgi6x7finf7i6sxyw2";
    rev = "1a554833a70694ab142b9179bfac996143f68d9e";
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
  homepage = http://elm-lang.org;
  description = "A build tool for Elm projects";
  license = stdenv.lib.licenses.bsd3;
}
