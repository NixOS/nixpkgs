{ cabal, blazeBuilder, dataenc, random, text }:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.3.0.3";
  sha256 = "0aag2mj1jchgwgnlh6hmv9qz78qjxffn1b52nwl6257sk0qv6va6";
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
