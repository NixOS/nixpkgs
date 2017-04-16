{ cabal, binary, blazeBuilder, network }:

cabal.mkDerivation (self: {
  pname = "memcache";
  version = "0.0.0";
  sha256 = "0bwnr28wn5anc2bcg2fwci3rgn2ykxp1gg58qg97d7lw1djmikwr";
  buildDepends = [ binary blazeBuilder network ];
  meta = {
    homepage = "https://github.com/dterei/memcache-hs";
    description = "A memcached client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
