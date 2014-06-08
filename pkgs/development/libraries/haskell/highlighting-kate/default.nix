{ cabal, blazeHtml, filepath, mtl, parsec, regexPcre, utf8String }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.8.1";
  sha256 = "10hbsra6ifjj765shf6x4c8kgb5bmv3zcgya3lcswvwa9xn78h9p";
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
