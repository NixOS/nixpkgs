{ cabal, attoparsec, caseInsensitive, hashable, network, snap, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "snap-cors";
  version = "1.2.2";
  sha256 = "1f32sj7y87lr0wjs3j3ynh95c4j4yx4fzizbgdfnjai1apcjkhcs";
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
