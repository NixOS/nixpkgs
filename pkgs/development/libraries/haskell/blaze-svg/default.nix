{ cabal, blazeMarkup, mtl }:

cabal.mkDerivation (self: {
  pname = "blaze-svg";
  version = "0.3.3.1";
  sha256 = "00i0apyklvmkr4w30d4r86gcg86h35sc3ncvqax70827126cdmsj";
  buildDepends = [ blazeMarkup mtl ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/deepakjois/blaze-svg";
    description = "SVG combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
