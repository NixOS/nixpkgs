{ cabal, free, pipes, pipesParse, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-group";
  version = "1.0.0";
  sha256 = "1izc2z3cwz7dihhfrngjyiaxmcpp794ragbl6v17y8c2pj0s34kh";
  buildDepends = [ free pipes pipesParse transformers ];
  meta = {
    description = "Group streams into substreams";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
