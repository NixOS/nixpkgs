{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "cipher-aes128";
  version = "0.5";
  sha256 = "14rwnz0nwmy1zch1ywjxf2fgfs1xj84l4n785rhb6npmx6k7rmqd";
  buildDepends = [ cereal cryptoApi tagged ];
  meta = {
    homepage = "https://github.com/TomMD/cipher-aes128";
    description = "AES128 using AES-NI when available";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
