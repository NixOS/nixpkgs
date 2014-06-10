{ cabal, binary, hashtables, stringsearch }:

cabal.mkDerivation (self: {
  pname = "RefSerialize";
  version = "0.3.1.3";
  sha256 = "0qrca0jismpvjy7i4xx19ljrj72gqcmwqg47a51ykncsvci0fjrm";
  buildDepends = [ binary hashtables stringsearch ];
  meta = {
    description = "Write to and read from ByteStrings maintaining internal memory references";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tomberek ];
  };
})
