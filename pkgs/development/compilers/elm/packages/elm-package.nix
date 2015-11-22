{ mkDerivation, aeson, aeson-pretty, ansi-wl-pprint, base, binary
, bytestring, containers, directory, elm-compiler, fetchgit, filepath, HTTP
, http-client, http-client-tls, http-types, mtl, network
, optparse-applicative, pretty, stdenv, text, time
, unordered-containers, vector, zip-archive
}:
mkDerivation {
  pname = "elm-package";
  version = "0.16";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-package";
    sha256 = "0jxsby8l9fz5al55qccmw9rmb340v1b6hf87g6irf7db4fl8jrw3";
    rev = "6305a7954a45d1635d6a7185f2dcf136c376074f";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty base binary bytestring containers directory
    elm-compiler filepath HTTP http-client http-client-tls http-types
    mtl network text time unordered-containers vector zip-archive
  ];
  executableHaskellDepends = [
    aeson aeson-pretty ansi-wl-pprint base binary bytestring containers
    directory elm-compiler filepath HTTP http-client http-client-tls
    http-types mtl network optparse-applicative pretty text time
    unordered-containers vector zip-archive
  ];
  jailbreak = true;
  homepage = "http://github.com/elm-lang/elm-package";
  description = "Package manager for Elm libraries";
  license = stdenv.lib.licenses.bsd3;
}
