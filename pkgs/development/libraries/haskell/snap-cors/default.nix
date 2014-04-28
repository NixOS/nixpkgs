{ cabal, attoparsec, caseInsensitive, hashable, network, snap, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "snap-cors";
  version = "1.2.3";
  sha256 = "0frm1jghm5n1pivcdx45cf7nymny25ijfslg52cm75m55d4l2lvv";
  buildDepends = [
    attoparsec caseInsensitive hashable network snap text transformers
    unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/ocharles/snap-cors";
    description = "Add CORS headers to Snap applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
