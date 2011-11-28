{ cabal, blazeBuilder, dataenc, random, text }:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.4";
  sha256 = "0hlyk3mypn9iw7g8hhn528ycbm3qayiczwf4paw0sxd6xsg9a28s";
  buildDepends = [ blazeBuilder dataenc random text ];
  meta = {
    homepage = "http://github.com/snoyberg/mime-mail";
    description = "Compose MIME email messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
