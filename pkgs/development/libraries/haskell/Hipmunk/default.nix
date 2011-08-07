{cabal, StateVar, transformers} :

cabal.mkDerivation (self : {
  pname = "Hipmunk";
  version = "5.2.0.2";
  sha256 = "18ly05q953x59smqqrhwjlfa1v6lqma0xiarmr689i63zzb7ji8z";
  propagatedBuildInputs = [ StateVar transformers ];
  meta = {
    homepage = "http://patch-tag.com/r/felipe/hipmunk/home";
    description = "A Haskell binding for Chipmunk.";
    license = "unknown";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
