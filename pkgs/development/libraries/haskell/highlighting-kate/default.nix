{ cabal, blazeHtml, Cabal, filepath, mtl, parsec, regexPcreBuiltin
}:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.0.4";
  sha256 = "1kn73gcjhndb5wbdy9hbjgar1bdcmy8cy831ib4ik1fn62zmvxrf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml Cabal filepath mtl parsec regexPcreBuiltin
  ];
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
