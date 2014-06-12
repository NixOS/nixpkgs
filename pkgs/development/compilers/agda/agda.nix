{ cabal, alex, binary, boxes, dataHash, deepseq, emacs, equivalence
, filepath, geniplate, happy, hashable, hashtables, haskeline
, haskellSrcExts, mtl, parallel, QuickCheck, STMonadTrans, strict
, text, time, transformers, unorderedContainers, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.4.0";
  sha256 = "0w8fxfg4b2w7d2k7zanimcg90h240rm5smm5m4i0ydr8zw8zv3yn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary boxes dataHash deepseq equivalence filepath geniplate
    hashable hashtables haskeline haskellSrcExts mtl parallel
    QuickCheck STMonadTrans strict text time transformers
    unorderedContainers xhtml zlib
  ];
  buildTools = [ alex emacs happy ];
  postInstall = ''
    $out/bin/agda $out/share/Agda-*/lib/prim/Agda/Primitive.agda
    $out/bin/agda-mode compile
  '';
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "A dependently typed functional programming language and proof assistant";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
