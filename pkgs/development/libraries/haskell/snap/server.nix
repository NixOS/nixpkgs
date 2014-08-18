{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, caseInsensitive, enumerator
, MonadCatchIOTransformers, mtl, network, snapCore, text, time
, unixCompat, HsOpenSSL, useOpenssl ? false
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.4.5";
  sha256 = "09399vlqgic0iwmx31c01bjpbdblw8gayxnz71lwzkixqibkbbip";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    caseInsensitive enumerator MonadCatchIOTransformers mtl network
    snapCore text time unixCompat
  ] ++ self.stdenv.lib.optional useOpenssl HsOpenSSL;
  configureFlags = [ ] ++ self.stdenv.lib.optional useOpenssl "-fopenssl";
  meta = {
    homepage = "http://snapframework.com/";
    description = "A fast, iteratee-based, epoll-enabled web server for the Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
