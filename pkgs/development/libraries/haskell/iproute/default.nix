{ cabal, appar, byteorder, network }:

cabal.mkDerivation (self: {
  pname = "iproute";
  version = "1.2.8";
  sha256 = "0vialraqr8r5d4bvknp3hd9412vpva43nqyv6y7bj0505xxr06l2";
  buildDepends = [ appar byteorder network ];
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/iproute/";
    description = "IP Routing Table";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
