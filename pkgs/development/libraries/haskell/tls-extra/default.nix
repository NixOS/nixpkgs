{cabal, certificate, cryptoApi, cryptocipher, cryptohash, mtl,
 network, text, tls, vector} :

cabal.mkDerivation (self : {
  pname = "tls-extra";
  version = "0.3.1";
  sha256 = "1zj8l5nglfaarbbzb1icil6cp6rjqfs33nryxc34akz22zwwmln4";
  propagatedBuildInputs = [
    certificate cryptoApi cryptocipher cryptohash mtl network text tls
    vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls-extra";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
