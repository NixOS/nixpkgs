{ mkDerivation, array, base, fetchzip, lib }:
mkDerivation {
  pname = "stm";
  version = "2.5.3.1";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/stm-2.5.3.1/stm-2.5.3.1.tar.gz";
    sha256 = "0lcxifbwxi1fmrnpvlr1ychiy847n51xdhk9y4c9cm55w4nms6bz";
  };
  libraryHaskellDepends = [ array base ];
  homepage = "https://wiki.haskell.org/Software_transactional_memory";
  description = "Software Transactional Memory";
  license = lib.licenses.bsd3;
}
