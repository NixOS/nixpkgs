{cabal, primitive, vector} :

cabal.mkDerivation (self : {
  pname = "mwc-random";
  version = "0.10.0.0";
  sha256 = "0pbzwq7jckjx0q7rpzhvjd2iam30yml0mwkz1jff8vl832z5xa8v";
  propagatedBuildInputs = [ primitive vector ];
  meta = {
    homepage = "https://github.com/bos/mwc-random";
    description = "Fast, high quality pseudo random number generation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
