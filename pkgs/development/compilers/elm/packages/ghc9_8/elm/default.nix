{
  mkDerivation,
  ansi-terminal,
  ansi-wl-pprint,
  array,
  base,
  binary,
  bytestring,
  containers,
  crypton,
  directory,
  edit-distance,
  fetchgit,
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
  version = "0.19.3";
  src = fetchgit {
    url = "https://github.com/elm/compiler";
    sha256 = "1phbk2qhki85r3wzs684s7xj2s2scqh3b9phdacgkd3r3bxd5ymi";
    rev = "fd5a6d68f8e3a85efee13143ff4a73edae6a761b";
    fetchSubmodules = true;
  };
  patches = [ ./ansi-terminal-1.1.patch ];
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    ansi-terminal
    ansi-wl-pprint
    array
    base
    binary
    bytestring
    containers
    crypton
    directory
    edit-distance
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
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
  mainProgram = "elm";
}
