{ mkDerivation, aeson, aeson-pretty_0_7_2, ansi-wl-pprint, base, binary
, bytestring, containers, directory, edit-distance, elm-compiler
, fetchgit, filepath, HTTP, http-client, http-client-tls
, http-types, mtl, network, optparse-applicative, parallel-io
, pretty, stdenv, text, time, unordered-containers, vector
, zip-archive
}:
mkDerivation {
  pname = "elm-package";
  version = "0.17.1";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-package";
    sha256 = "0dnn871py0pvzxsjjggy5ww2zj9g71c2dcnp38rcr4nbj8yxik85";
    rev = "9011ccdbced1d06aa60de0e3096e609ef44d26dd";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty_0_7_2 ansi-wl-pprint base binary bytestring containers
    directory edit-distance elm-compiler filepath HTTP http-client
    http-client-tls http-types mtl network parallel-io text time
    unordered-containers vector zip-archive
  ];
  executableHaskellDepends = [
    aeson aeson-pretty_0_7_2 ansi-wl-pprint base binary bytestring containers
    directory edit-distance elm-compiler filepath HTTP http-client
    http-client-tls http-types mtl network optparse-applicative
    parallel-io pretty text time unordered-containers vector
    zip-archive
  ];
  jailbreak = true;
  homepage = "http://github.com/elm-lang/elm-package";
  description = "Package manager for Elm libraries";
  license = stdenv.lib.licenses.bsd3;
}
