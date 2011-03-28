{cabal, parsec, time}:

cabal.mkDerivation (self : {
  pname = "wxdirect";
  version = "0.12.1.3";
  sha256 = "da59315339dc78b3bfbe08c1681d53c74a56e7c3de0f41a90099bd289b1bfb11";
  preConfigure = ''
    sed -i 's|\(containers.*\) && < 0.4|\1|' ${self.pname}.cabal
    sed -i 's|\(time.*\) && < 1.2|\1|' ${self.pname}.cabal
  '';
  propagatedBuildInputs = [parsec time];
  meta = {
    description = "helper tool for building wxHaskell";
  };
})

