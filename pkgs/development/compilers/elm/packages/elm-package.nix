{ mkDerivation, aeson, aeson-pretty, ansi-wl-pprint, base, binary
, bytestring, containers, directory, elm-compiler, fetchgit
, filepath, HTTP, http-client, http-client-tls, http-types, mtl
, network, optparse-applicative, pretty, process, stdenv, text
, time, unordered-containers, vector, zip-archive
}:
mkDerivation {
  pname = "elm-package";
  version = "0.5.1";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-package";
    sha256 = "0d69e68831f4a86c6c02aed33fc3a6aca87636a7fb0bb6e39ffc74ddd15b5435";
    rev = "365e2d86a8222c92e50951c7d30b3c5db44c383d";
  };
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aeson-pretty ansi-wl-pprint base binary bytestring containers
    directory elm-compiler filepath HTTP http-client http-client-tls
    http-types mtl network optparse-applicative pretty process text
    time unordered-containers vector zip-archive
  ];
  jailbreak = true;
  homepage = "http://github.com/elm-lang/elm-package";
  description = "Package manager for Elm libraries";
  license = stdenv.lib.licenses.bsd3;
}
