{
  mkDerivation,
  base,
  containers,
  deepseq,
  directory,
  fetchzip,
  filepath,
  lib,
  time,
}:
mkDerivation {
  pname = "hpc";
  version = "0.7.0.2";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/hpc-0.7.0.2/hpc-0.7.0.2.tar.gz";
    sha256 = "0a9kknziai12nzv3z74zwgrlaw27jz3hp3r26lw0ddwl0hwmczbs";
  };
  libraryHaskellDepends = [
    base
    containers
    deepseq
    directory
    filepath
    time
  ];
  description = "Code Coverage Library for Haskell";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
