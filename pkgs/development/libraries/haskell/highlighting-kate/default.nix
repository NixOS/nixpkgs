{ cabal, blazeHtml, filepath, mtl, parsec, regexPcre, utf8String }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.8.3";
  sha256 = "03x9vp6mvk9hxs92cmy42aqiyh4prnh343xg36znyjii6xw2x3mf";
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
