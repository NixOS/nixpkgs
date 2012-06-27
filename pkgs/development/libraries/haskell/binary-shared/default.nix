{ cabal, binary, mtl }:

cabal.mkDerivation (self: {
  pname = "binary-shared";
  version = "0.8.2";
  sha256 = "05cqdpclb4xc6ydwdpxfi3bvaaw7syxlmb5r9kxjcp3f6fji5rm2";
  buildDepends = [ binary mtl ];
  meta = {
    homepage = "http://www.leksah.org";
    description = "Sharing for the binary package";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
