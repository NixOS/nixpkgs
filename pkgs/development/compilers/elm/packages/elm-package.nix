{ mkDerivation, aeson, aeson-pretty_0_7_2, ansi-wl-pprint, base, binary
, bytestring, containers, directory, edit-distance, elm-compiler
, fetchgit, filepath, HTTP, http-client, http-client-tls
, http-types, mtl, network, optparse-applicative, parallel-io
, pretty, stdenv, text, time, unordered-containers, vector
, zip-archive
}:
mkDerivation {
  pname = "elm-package";
  version = "0.18";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-package";
    sha256 = "19krnkjvfk02gmmic5h5i1i0lw7s30927bnd5g57cj8nqbigysv7";
    rev = "8bd150314bacab5b6fc451927aa01deec2276fbf";
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
  homepage = https://github.com/elm-lang/elm-package;
  description = "Package manager for Elm libraries";
  license = stdenv.lib.licenses.bsd3;
}
