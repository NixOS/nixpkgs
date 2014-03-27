{ cabal, base16Bytestring, base64Bytestring, chunkedData, conduit
, hspec, monoTraversable, mwcRandom, primitive, silently
, systemFileio, systemFilepath, text, transformers
, transformersBase, unixCompat, vector, void
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.2.3.1";
  sha256 = "078i0727nhy75y6bxav6sxr1gz9cq04nvskdnzwabljppd34dqg4";
  buildDepends = [
    base16Bytestring base64Bytestring chunkedData conduit
    monoTraversable mwcRandom primitive systemFileio systemFilepath
    text transformers transformersBase unixCompat vector void
  ];
  testDepends = [
    base16Bytestring base64Bytestring chunkedData hspec monoTraversable
    mwcRandom silently systemFilepath text transformers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/conduit-combinators";
    description = "Commonly used conduit functions, for both chunked and unchunked data";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
