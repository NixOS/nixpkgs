{ cabal, mtl, typeEquality }:

cabal.mkDerivation (self: {
  pname = "RepLib";
  version = "0.5.3.2";
  sha256 = "0adqq49kbdh0755694hrldsd9rm76bpj5ylmmli4fjxs203m5f5y";
  buildDepends = [ mtl typeEquality ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic programming library with representation types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
