{ cabal, blazeHtml, filepath, mtl, parsec, regexPcreBuiltin }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.0.5";
  sha256 = "005k3yc406h4wz5jk47nk4g5qb409kd7dwyw7n9g31gjqxp73p8v";
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
