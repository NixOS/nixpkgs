{ cabal, alex, binary, boxes, dataHash, deepseq, emacs, equivalence
, filepath, geniplate, happy, hashable, hashtables, haskeline
, haskellSrcExts, mtl, parallel, QuickCheck, STMonadTrans, strict
, text, time, transformers, unorderedContainers, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.4.0.1";
  sha256 = "11my5k606zvra3w3m1wllc4dy5mfv4lr32fqd579vqcks6wpirjq";
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
    $out/bin/agda -c --no-main $(find $out/share -name Primitive.agda)
    $out/bin/agda-mode compile
  '';
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "A dependently typed functional programming language and proof assistant";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
