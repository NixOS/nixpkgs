{ cabal, blazeHtml, mtl, parsec, regexPcreBuiltin }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.0.2";
  sha256 = "012hr5ci9j4fwnrc1ypx6ca562vzqlfk5phjs4xl3llxv8afdhgl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ blazeHtml mtl parsec regexPcreBuiltin ];
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
