{ mkDerivation, aeson, ansi-terminal, ansi-wl-pprint, base, binary
, blaze-html, blaze-markup, bytestring, containers, directory
, elm-compiler, elm-package, fetchgit, filepath, mtl, optparse-applicative
, stdenv, text, time
}:
mkDerivation {
  pname = "elm-make";
  version = "0.16";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-make";
    sha256 = "1g6f6p5lv2rw408b4w4kja4c8plsp1wxm8s52cclxyv6h1n21qds";
    rev = "e3bfc3e3d04c9b47e18fac289c796caec88d4fef";
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
