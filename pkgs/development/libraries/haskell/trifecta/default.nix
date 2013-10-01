{ cabal, ansiTerminal, ansiWlPprint, blazeBuilder, blazeHtml
, blazeMarkup, charset, comonad, deepseq, doctest, filepath
, fingertree, hashable, lens, mtl, parsers, reducers, semigroups
, transformers, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "trifecta";
  version = "1.1";
  sha256 = "19wnblpn31hvdi5dc8ir24s0hfjj4vvzr43gg9ydl2qdjq6s166w";
  buildDepends = [
    ansiTerminal ansiWlPprint blazeBuilder blazeHtml blazeMarkup
    charset comonad deepseq fingertree hashable lens mtl parsers
    reducers semigroups transformers unorderedContainers utf8String
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/trifecta/";
    description = "A modern parser combinator library with convenient diagnostics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
