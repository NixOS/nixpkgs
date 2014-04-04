{ cabal, base16Bytestring, base64Bytestring, chunkedData, conduit
, conduitExtra, hspec, monadControl, monoTraversable, mwcRandom
, primitive, resourcet, silently, systemFileio, systemFilepath
, text, transformers, transformersBase, unixCompat, vector, void
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.2.4";
  sha256 = "0pxzvxd1j48l7j2anv61bxv1accl0jc6vdf9vv0l3s2358smzwwv";
  buildDepends = [
    base16Bytestring base64Bytestring chunkedData conduit conduitExtra
    monadControl monoTraversable mwcRandom primitive resourcet
    systemFileio systemFilepath text transformers transformersBase
    unixCompat vector void
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
