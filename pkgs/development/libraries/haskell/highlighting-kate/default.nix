{ cabal, blazeHtml, filepath, mtl, parsec, regexPcreBuiltin }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.2";
  sha256 = "1a3aifknbxm3v0lvqisdc6zqgki9x9z12jdrmijxmxq1riwwalr2";
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
