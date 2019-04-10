{ mkDerivation, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, containers, directory, edit-distance, fetchgit
, file-embed, filepath, ghc-prim, haskeline, HTTP, http-client
, http-client-tls, http-types, language-glsl, logict, mtl, network
, parsec, process, raw-strings-qq, scientific, SHA, snap-core
, snap-server, stdenv, template-haskell, text, time
, unordered-containers, utf8-string, vector, zip-archive
}:
mkDerivation {
  pname = "elm";
  version = "0.19.0";
  src = fetchgit {
    url = "https://github.com/elm/compiler";
    sha256 = "13jks6c6i80z71mjjfg46ri570g5ini0k3xw3857v6z66zcl56x4";
    rev = "d5cbc41aac23da463236bbc250933d037da4055a";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    ansi-terminal ansi-wl-pprint base binary bytestring containers
    directory edit-distance file-embed filepath ghc-prim haskeline HTTP
    http-client http-client-tls http-types language-glsl logict mtl
    network parsec process raw-strings-qq scientific SHA snap-core
    snap-server template-haskell text time unordered-containers
    utf8-string vector zip-archive
  ];
  homepage = "http://elm-lang.org";
  description = "The `elm` command line interface";
  license = stdenv.lib.licenses.bsd3;
}
