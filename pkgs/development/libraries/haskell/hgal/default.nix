{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "hgal";
  version = "2.0.0.2";
  sha256 = "17qw8izy54042g56mp3hdbmqcyk95cdarg58xggniwd85q2l5dpi";
  buildDepends = [ mtl ];
  meta = {
    description = "library for computation automorphism group and canonical labelling of a graph";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
