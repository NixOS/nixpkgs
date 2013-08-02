{ cabal, base64Bytestring, blazeBuilder, filepath, hspec, random
, text
}:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.4.2";
  sha256 = "1v9qdj53swhg8xg9s2x0m6d6xaff5ya6bpdifya2vsp08fmgn4l9";
  buildDepends = [
    base64Bytestring blazeBuilder filepath random text
  ];
  testDepends = [ blazeBuilder hspec ];
  meta = {
    homepage = "http://github.com/snoyberg/mime-mail";
    description = "Compose MIME email messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
