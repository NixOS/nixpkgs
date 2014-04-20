{ cabal, alex, binary, deepseq, emacs, filepath, geniplate, happy
, hashable, hashtables, haskeline, haskellSrcExts, mtl, parallel
, QuickCheck, text, time, unorderedContainers, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.3.2.2";
  sha256 = "0zr2rg2yvq6pqg69c6h7hqqpc5nj8prfhcvj5p2alkby0vs110qc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary deepseq filepath geniplate hashable hashtables haskeline
    haskellSrcExts mtl parallel QuickCheck text time
    unorderedContainers xhtml zlib
  ];
  buildTools = [ alex emacs happy ];
  jailbreak = true;
  postInstall = ''
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
