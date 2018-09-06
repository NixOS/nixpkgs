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
    sha256 = "0s93z9vr0vp5w894ghc5s34nsq09sg1msf59zfiba87sid5vgjqy";
    rev = "32059a289d27e303fa1665e9ada0a52eb688f302";
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
