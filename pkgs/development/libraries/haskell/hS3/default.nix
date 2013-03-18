{ cabal, Crypto, dataenc, HTTP, hxt, MissingH, network, random
, regexCompat, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hS3";
  version = "0.5.7";
  sha256 = "1p5p6vwazqi5kpi3i0msbgcdf6flp25b2v1an6lvj7y8dx1pk6f2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Crypto dataenc HTTP hxt MissingH network random regexCompat
    utf8String
  ];
  meta = {
    homepage = "http://gregheartsfield.com/hS3/";
    description = "Interface to Amazon's Simple Storage Service (S3)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
