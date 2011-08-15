{ cabal, mtl, network, parsec, random, syb, fetchgit }:

cabal.mkDerivation (self: {
  pname = "WebServer";
  version = "1.2";

  src = fetchgit {
    url = git://github.com/arjunguha/haskell-web.git;
    rev = "931a2ec1744cd5c5139af9a3fe8195a36dc3acec" ;
  };

  buildDepends = [ mtl network parsec random syb ];
  meta = {
    homepage = "http://github.com/arjunguha/haskell-web";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
