{ cabal, blazeHtml, mtl, parsec, regexPcreBuiltin }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.0.1";
  sha256 = "05r8w4366gi64l65k6vyda1cs96ld8i2dgch8r5fmxwiaa8dcs1l";
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
