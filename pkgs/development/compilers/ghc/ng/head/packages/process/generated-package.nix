{
  mkDerivation,
  base,
  deepseq,
  directory,
  fetchzip,
  filepath,
  lib,
  unix,
}:
mkDerivation {
  pname = "process";
  version = "1.6.29.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/process-1.6.29.0/process-1.6.29.0.tar.gz";
    sha256 = "1ffllqh0sy79wasndjk2bgkgp2fkcdsxafjqy56j0i6k9anb915j";
  };
  libraryHaskellDepends = [
    base
    deepseq
    directory
    filepath
    unix
  ];
  description = "Process libraries";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
