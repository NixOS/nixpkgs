{ cabal, blazeHtml, snapCore }:

cabal.mkDerivation (self: {
  pname = "snap-blaze";
  version = "0.2.1.2";
  sha256 = "136i5q9ipfqrh7fw8rgn1ws6zkjdrfwfq9wpccrm8dg3l61380wh";
  buildDepends = [ blazeHtml snapCore ];
  meta = {
    homepage = "http://github.com/jaspervdj/snap-blaze";
    description = "blaze-html integration for Snap";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
