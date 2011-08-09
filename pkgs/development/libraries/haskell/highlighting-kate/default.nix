{cabal, parsec, regexPcreBuiltin, xhtml} :

cabal.mkDerivation (self : {
  pname = "highlighting-kate";
  version = "0.2.10";
  sha256 = "0cw89qsslrp4zh47ics7bg79fkqnxpnyz1a9xws0xzd9xmg3zrhh";
  propagatedBuildInputs = [ parsec regexPcreBuiltin xhtml ];
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
