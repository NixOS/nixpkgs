{ cabal, regexPosix }:

cabal.mkDerivation (self: {
  pname = "nixos-types";
  version = "1.1";
  sha256 = "0vnlhq2pjnslq1h9h3lyaxw604s3zdhs7k8hfr35m178rdm3a5az";
  buildDepends = [ regexPosix ];
  meta = {
    homepage = "http://github.com/haskell4nix/nixos-types";
    description = "Data types representing the Nix language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
