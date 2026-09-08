{
  mkDerivation,
  array,
  base,
  deepseq,
  fetchzip,
  lib,
  template-haskell,
}:
mkDerivation {
  pname = "containers";
  version = "0.8";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/containers-0.8/containers-0.8.tar.gz";
    sha256 = "06mmyljfj41hg5rzr9d2fb61gd2a11waicpk7dcy3hxrqvfgs8yc";
  };
  libraryHaskellDepends = [
    array
    base
    deepseq
    template-haskell
  ];
  homepage = "https://github.com/haskell/containers";
  description = "Assorted concrete container types";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
