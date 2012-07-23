{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "process-extras";
  version = "0.1.1";
  sha256 = "0qnkclmjd5y0jpdxp4y2ynqlcdlsvck65269k0j4hy5zkyydbpv6";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/davidlazar/process-extras";
    description = "Process extras";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
