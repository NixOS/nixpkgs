{ cabal, extensibleExceptions, hslogger, mtl, network, parsec
, random, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "happstack-util";
  version = "6.0.2";
  sha256 = "03qlnclpg72iflry1xlkd0sxqm6nybvx113la9r0cmsnz17y546a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions hslogger mtl network parsec random time
    unixCompat
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Web framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
