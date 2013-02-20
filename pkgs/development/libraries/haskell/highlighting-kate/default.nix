{ cabal, blazeHtml, filepath, mtl, parsec, regexPcre }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.3.6";
  sha256 = "0ypgw56gaa2hvh05ks079lfcaaynki3da471g39f23m3scgkawlr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ blazeHtml filepath mtl parsec regexPcre ];
  jailbreak = true;
  prePatch = "sed -i -e 's|regex-pcre-builtin|regex-pcre|' highlighting-kate.cabal";
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
