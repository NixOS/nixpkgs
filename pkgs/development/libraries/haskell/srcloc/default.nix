{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "srcloc";
  version = "0.2.1";
  sha256 = "03b0ra5g7mqcjjfnhm84mv4ph454j08pb9dwxrv9zfwk1kiqb2ss";
  buildDepends = [ syb ];
  noHaddock = true;
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Data types for managing source code locations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
