{ cabal, attoparsec, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "0.2.0";
  sha256 = "11jcsqyqc33xn980rac7fmdgj99dg4bp75b5whqzpnr67ginjjv9";
  buildDepends = [ attoparsec conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Turn attoparsec parsers into sinks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
