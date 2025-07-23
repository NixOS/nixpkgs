{
  mkDerivation,
  ansi-terminal,
  ansi-wl-pprint,
  base,
  binary,
  bytestring,
  containers,
  directory,
  edit-distance,
  fetchgit,
  file-embed,
  filelock,
  filepath,
  ghc-prim,
  haskeline,
  HTTP,
  http-client,
  http-client-tls,
  http-types,
  language-glsl,
  lib,
  mtl,
  network,
  parsec,
  process,
  raw-strings-qq,
  scientific,
  SHA,
  snap-core,
  snap-server,
  template-haskell,
  time,
  unordered-containers,
  utf8-string,
  vector,
  zip-archive,
}:
mkDerivation {
  pname = "elm";
  version = "0.19.1";
  src = fetchgit {
    url = "https://github.com/elm/compiler";
    sha256 = "1h9jhwlv1pqqna5s09vd72arwhhjn0dlhv0w9xx5771x0xryxxg8";
    rev = "2f6dd29258e880dbb7effd57a829a0470d8da48b";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    ansi-terminal
    ansi-wl-pprint
    base
    binary
    bytestring
    containers
    directory
    edit-distance
    file-embed
    filelock
    filepath
    ghc-prim
    haskeline
    HTTP
    http-client
    http-client-tls
    http-types
    language-glsl
    mtl
    network
    parsec
    process
    raw-strings-qq
    scientific
    SHA
    snap-core
    snap-server
    template-haskell
    time
    unordered-containers
    utf8-string
    vector
    zip-archive
  ];
  homepage = "https://elm-lang.org";
  description = "The `elm` command line interface";
  license = lib.licenses.bsd3;
  mainProgram = "elm";
}
