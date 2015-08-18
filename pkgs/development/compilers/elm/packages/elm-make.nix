{ mkDerivation, aeson, ansi-wl-pprint, base, binary, blaze-html
, blaze-markup, bytestring, containers, directory, elm-compiler
, elm-package, fetchgit, filepath, mtl, optparse-applicative
, stdenv, text
}:
mkDerivation {
  pname = "elm-make";
  version = "0.2";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-make";
    sha256 = "b618e827ca01ddeae38624f4bf5baa3dc4cb6e9e3c9bf15f2dda5a7c756bca33";
    rev = "d9bedfdadc9cefce8e5249db6a316a5e712158d0";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson ansi-wl-pprint base binary blaze-html blaze-markup bytestring
    containers directory elm-compiler elm-package filepath mtl
    optparse-applicative text
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "A build tool for Elm projects";
  license = stdenv.lib.licenses.bsd3;
}
