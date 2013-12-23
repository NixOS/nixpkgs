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
  postPatch = ''
    substituteInPlace trifecta.cabal \
      --replace "blaze-html           >= 0.5     && < 0.6," "blaze-html           >= 0.5     && < 0.7," \
      --replace "hashable             >= 1.2     && < 1.3," "hashable             >= 1.1     && < 1.3," \
      --replace "fingertree           >= 0.0.1   && < 0.1," "fingertree           >= 0.0.1   && < 0.2," \
      --replace "comonad              == 3.*,"              "comonad              >= 3       && < 5,"
  '';
  meta = {
    homepage = "http://github.com/ekmett/trifecta/";
    description = "A modern parser combinator library with convenient diagnostics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
