{ cabal, blazeMarkup, mtl }:

cabal.mkDerivation (self: {
  pname = "blaze-svg";
  version = "0.3.3.0";
  sha256 = "1wi4nc73ic3qmbx6v9fniacwcz2nlvmp5snn144fdiwb22klfn5f";
  buildDepends = [ blazeMarkup mtl ];
  meta = {
    homepage = "https://github.com/deepakjois/blaze-svg";
    description = "SVG combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
