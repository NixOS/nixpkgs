{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.1.4";
  sha256 = "1a8z9r75jk4z4diyigk0qzljkjqirxm30vf3jp75plnc9irysnw5";
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
