{ cabal, blazeHtml, filepath, mtl, parsec, regexPcreBuiltin }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.0.6";
  sha256 = "068ksmi8kdjm00279lnnhih4sqs9yh8mnvvn71brwak5r361m056";
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
