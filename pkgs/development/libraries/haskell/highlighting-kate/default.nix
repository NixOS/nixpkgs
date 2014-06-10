{ cabal, blazeHtml, filepath, mtl, parsec, regexPcre, utf8String }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.8.2";
  sha256 = "1c85yfzi3ri3j1fmqvd4pc4pp95jpm62a2nbbibpybl2h88dsjsb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml filepath mtl parsec regexPcre utf8String
  ];
  prePatch = "sed -i -e 's|regex-pcre-builtin >= .*|regex-pcre|' highlighting-kate.cabal";
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
