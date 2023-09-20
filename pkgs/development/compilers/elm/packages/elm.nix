{ mkDerivation, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, containers, directory, edit-distance, fetchgit
, file-embed, filelock, filepath, ghc-prim, haskeline, HTTP
, http-client, http-client-tls, http-types, language-glsl, mtl
, network, parsec, process, raw-strings-qq, scientific, SHA
, snap-core, snap-server, lib, template-haskell, time
, unordered-containers, utf8-string, vector, zip-archive
}:

mkDerivation {
  pname = "elm";
  version = "0.19.1";
  src = fetchgit {
    url = "https://github.com/elm/compiler";
    sha256 = "1rdg3xp3js9xadclk3cdypkscm5wahgsfmm4ldcw3xswzhw6ri8w";
    rev = "c9aefb6230f5e0bda03205ab0499f6e4af924495";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    ansi-terminal ansi-wl-pprint base binary bytestring containers
    directory edit-distance file-embed filelock filepath ghc-prim
    haskeline HTTP http-client http-client-tls http-types language-glsl
    mtl network parsec process raw-strings-qq scientific SHA snap-core
    snap-server template-haskell time unordered-containers utf8-string
    vector zip-archive
  ];
  homepage = "https://elm-lang.org";
  description = "The `elm` command line interface";
  license = lib.licenses.bsd3;
}
