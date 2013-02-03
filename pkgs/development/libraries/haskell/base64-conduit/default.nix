{ cabal, base64Bytestring, conduit }:

cabal.mkDerivation (self: {
  pname = "base64-conduit";
  version = "0.5.1";
  sha256 = "1zmp6iv55rac7x7w59az7zaarq79fr7zvgg2wcb5b627axlw909l";
  buildDepends = [ base64Bytestring conduit ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Base64-encode and decode streams of bytes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
