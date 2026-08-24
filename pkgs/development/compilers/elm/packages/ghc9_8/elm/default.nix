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
  version = "0.19.2";
  src = fetchgit {
    url = "https://github.com/elm/compiler";
    sha256 = "0npadfvk5gyiifq4095yg7k8cr3hb28drdh07b77nxzwsqanp4s5";
    rev = "48befde196cbcbdf459114e36c02b52c49b58050";
    fetchSubmodules = true;
  };
  patches = [ ./ansi-terminal-1.1.patch ];
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
