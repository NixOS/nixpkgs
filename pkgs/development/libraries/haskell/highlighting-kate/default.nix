{ cabal, blazeHtml, filepath, mtl, parsec, regexPcre }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.3.3";
  sha256 = "08jxl2ba0kb4vj1qbdf4sas8bwbxzayzwsxnjvq358x57i5l302n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ blazeHtml filepath mtl parsec regexPcre ];
  prePatch = "sed -i -e 's|regex-pcre-builtin|regex-pcre|' highlighting-kate.cabal";
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
