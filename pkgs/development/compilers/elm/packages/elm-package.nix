{ mkDerivation, aeson, aeson-pretty, ansi-wl-pprint, base, binary
, bytestring, containers, directory, elm-compiler, fetchgit
, filepath, HTTP, http-client, http-client-tls, http-types, mtl
, network, optparse-applicative, pretty, stdenv, text, time
, unordered-containers, vector, zip-archive
}:
mkDerivation {
  pname = "elm-package";
  version = "0.17";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-package";
    sha256 = "0z86560a2f7w3ywqvzqghgz100z0yn8zsiixkw4lp5168krp4axg";
    rev = "fc0924210fe5a7c0af543769b1353dbb2ddf2f0c";
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
