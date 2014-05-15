{ cabal, hashable }:

cabal.mkDerivation (self: {
  pname = "nats";
  version = "0.2";
  sha256 = "05skqs5ahbrnwlsxjihkvmsw0n49k9mqdhrv9nqh4dmd1j622r73";
  buildDepends = [ hashable ];
  meta = {
    homepage = "http://github.com/ekmett/nats/";
    description = "Natural numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
