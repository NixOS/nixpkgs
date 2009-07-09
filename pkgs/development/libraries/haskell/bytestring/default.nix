{cabal}:

cabal.mkDerivation (self : {
  pname = "bytestring";
  version = "0.9.1.4";
  name = self.fname;
  sha256 = "00x620zkxhlmdxmb2icrq3a2wc6jichng6mn33xr2gsw102973xz";
  extraBuildInputs = [];
  meta = {
    description = "A time and space-efficient implementation of byte vectors using packed Word8 arrays [..]";
  };
})
