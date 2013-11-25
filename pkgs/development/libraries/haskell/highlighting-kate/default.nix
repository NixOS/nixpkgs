{ cabal, blazeHtml, filepath, mtl, parsec, regexPcre }:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.5.1";
  sha256 = "173g7dss3v3acbn6b5ajmc1n1v4wx2395cckw8n61myl7mzzbrry";
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
