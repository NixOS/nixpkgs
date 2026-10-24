{
  mkDerivation,
  base,
  bytestring,
  containers,
  directory,
  exceptions,
  fetchzip,
  filepath,
  HUnit,
  lib,
  process,
  stm,
  terminfo,
  text,
  transformers,
  unix,
}:
mkDerivation {
  pname = "haskeline";
  version = "0.8.3.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/haskeline-0.8.3.0/haskeline-0.8.3.0.tar.gz";
    sha256 = "19niqj3nj5sdpinkcvkq39jwn7m08ki7m7bwdhnrkivf7jv0fw2a";
  };
  configureFlags = [ "-fterminfo" ];
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    bytestring
    containers
    directory
    exceptions
    filepath
    process
    stm
    terminfo
    transformers
    unix
  ];
  executableHaskellDepends = [
    base
    containers
  ];
  testHaskellDepends = [
    base
    bytestring
    containers
    HUnit
    process
    text
    unix
  ];
  homepage = "https://github.com/haskell/haskeline";
  description = "A command-line interface for user input, written in Haskell";
  license = lib.licenses.bsd3;
  mainProgram = "haskeline-examples-Test";
}
