{ cabal, pcre }:

cabal.mkDerivation (self: {
  pname = "pcre-light";
  version = "0.4.0.1";
  sha256 = "07r863fcxhxnlvld732r1d3kd797ki71wyizfklbz0ccdxqq8cqj";
  extraLibraries = [ pcre ];
  meta = {
    homepage = "https://github.com/Daniel-Diaz/pcre-light";
    description = "A small, efficient and portable regex library for Perl 5 compatible regular expressions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
