{ cabal, base64Bytestring, conduit }:

cabal.mkDerivation (self: {
  pname = "base64-conduit";
  version = "0.5.0";
  sha256 = "0h4s4pivwjgdx6zmz5nvsgqxhzaq0a3b9h49m39fvn669f50nkf4";
  buildDepends = [ base64Bytestring conduit ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Base64-encode and decode streams of bytes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
