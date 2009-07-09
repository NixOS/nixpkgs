{cabal, bytestring, network}:

cabal.mkDerivation (self : {
  pname = "network-bytestring";
  version = "0.1.2.1";
  name = self.fname;
  sha256 = "0l5gxwc5pg49qyxb1jy3kn9j66a6pg9frw4c7dn1mrpqicm155am";
  extraBuildInputs = [bytestring network];
  meta = {
    description = "Source code suggestions";
  };
})
