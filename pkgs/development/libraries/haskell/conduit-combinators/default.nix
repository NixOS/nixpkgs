{ cabal, base16Bytestring, base64Bytestring, basicPrelude
, chunkedData, conduit, hspec, monoTraversable, mwcRandom
, primitive, silently, systemFileio, systemFilepath, text
, transformers, transformersBase, unixCompat, vector, void
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.2.3";
  sha256 = "05sb1v6rciaj7cj6lxv6pf9ai0k3q6cvvflcb4a7q6ql9xr3j7pr";
  buildDepends = [
    base16Bytestring base64Bytestring chunkedData conduit
    monoTraversable mwcRandom primitive systemFileio systemFilepath
    text transformers transformersBase unixCompat vector void
  ];
  testDepends = [
    base16Bytestring base64Bytestring basicPrelude chunkedData hspec
    monoTraversable mwcRandom silently text transformers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/conduit-combinators";
    description = "Commonly used conduit functions, for both chunked and unchunked data";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
