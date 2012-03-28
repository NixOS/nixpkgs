{ cabal, binary, mtl, syb, sybWithClass, sybWithClassInstancesText
, text, time
}:

cabal.mkDerivation (self: {
  pname = "happstack-data";
  version = "6.0.1";
  sha256 = "0v2ln4mdnild72p02mzjn8mn5srvjixsjqjgkdqzshvxjnnm95l8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary mtl syb sybWithClass sybWithClassInstancesText text time
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Happstack data manipulation libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
