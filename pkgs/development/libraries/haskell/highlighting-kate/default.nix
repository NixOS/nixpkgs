{ cabal, blazeHtml, filepath, mtl, parsec, regexPcreBuiltin }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.1";
  sha256 = "0l0g71rg7cs9rm4i04h88fm20868s0kf2da89297xlrm58zfv0jj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ blazeHtml filepath mtl parsec regexPcreBuiltin ];
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
