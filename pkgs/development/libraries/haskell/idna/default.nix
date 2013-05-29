{ cabal, punycode, stringprep, text }:

cabal.mkDerivation (self: {
  pname = "idna";
  version = "0.2";
  sha256 = "0gl1mn2fjyxdpzl024imspf7hk4xvj9r8mvisqnlkdsng8i5jnyz";
  buildDepends = [ punycode stringprep text ];
  meta = {
    description = "Implements IDNA (RFC 3490)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
