{ cabal }:

cabal.mkDerivation (self: {
  pname = "network-fancy";
  version = "0.1.5.2";
  sha256 = "039yrrir17sphkzarwl7hncj7fb4x471mh2lvpqixl3a6nij141c";
  meta = {
    homepage = "http://github.com/taruti/network-fancy";
    description = "Networking support with a cleaner API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
  preConfigure = ''substituteInPlace Setup.hs --replace '-> rt' '-> return ()' '';
})
