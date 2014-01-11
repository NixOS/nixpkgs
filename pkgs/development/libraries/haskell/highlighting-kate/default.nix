{ cabal, blazeHtml, filepath, mtl, parsec, regexPcre }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.6";
  sha256 = "1nd1ima3x7bb3lhkpzfw1qbl8g8mwp1ixk2w7nf2p1200c5zs49d";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ blazeHtml filepath mtl parsec regexPcre ];
  prePatch = "sed -i -e 's|regex-pcre-builtin|regex-pcre|' highlighting-kate.cabal";
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
