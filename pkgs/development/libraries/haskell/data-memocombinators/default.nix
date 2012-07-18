{ cabal, dataInttrie }:

cabal.mkDerivation (self: {
  pname = "data-memocombinators";
  version = "0.4.3";
  sha256 = "0mzvjgccm23y7mfaz9iwdy64amf69d7i8yq9fc9mjx1nyzxdrgsc";
  buildDepends = [ dataInttrie ];
  meta = {
    homepage = "http://github.com/luqui/data-memocombinators";
    description = "Combinators for building memo tables";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})

