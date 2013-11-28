{ cabal }:

cabal.mkDerivation (self: {
  pname = "stringsearch";
  version = "0.3.6.5";
  sha256 = "1mjvb1qr4fkxv5qvq4jfswa3dcj3dwzvwx7dbp2wqw8zand41lsq";
  meta = {
    homepage = "https://bitbucket.org/dafis/stringsearch";
    description = "Fast searching, splitting and replacing of ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
