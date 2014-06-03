{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "Shellac";
  version = "0.9.5.2";
  sha256 = "1js9la0hziqsmb56q9kzfycda2sw3xm4kv2y5q2h3zlw5gzc5xli";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://rwd.rdockins.name/shellac/home/";
    description = "A framework for creating shell envinronments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
