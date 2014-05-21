{ cabal, blazeMarkup, mtl }:

cabal.mkDerivation (self: {
  pname = "blaze-svg";
  version = "0.3.4";
  sha256 = "061011qrpqiyag9549hn0hfikvkrin5wb3cf0zfm9n80cgvzmqd3";
  buildDepends = [ blazeMarkup mtl ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/deepakjois/blaze-svg";
    description = "SVG combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
