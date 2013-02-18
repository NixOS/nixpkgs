{ cabal, blazeHtml, filepath, mtl, parsec, regexPcre }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.3.5";
  sha256 = "0m76h33igw77ndllgzkqgmygi7krc5vfjvizidsgris0zd1g2yv3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ blazeHtml filepath mtl parsec regexPcre ];
  prePatch = "sed -i -e 's|regex-pcre-builtin|regex-pcre|' highlighting-kate.cabal";
  jailbreak = true;
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
