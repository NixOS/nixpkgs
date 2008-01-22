{cabal}:

cabal.mkDerivation (self : {
  pname = "vty";
  version = "3.0.0";
  sha256 = "44ae53d06b8b45c14cd3861e860a38730ed9995ed56b1b3d9aba6641771f1947";
  meta = {
    description = "vty is a *very* simplistic library in the niche of ncurses";
  };
  preConfigure = ''
    sed -i 's|^Build-Depends:.*$|&, bytestring, containers|' ${self.pname}.cabal
  '';
})
