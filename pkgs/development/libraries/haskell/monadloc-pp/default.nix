{ cabal, filepath, haskellSrcExts, monadloc, syb }:

cabal.mkDerivation (self: {
  pname = "monadloc-pp";
  version = "0.3";
  sha256 = "0jr9ngcj3l6kd5cscll5kr3a4bp52sdjgrdxd1j5a21jyc3gdyvn";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath haskellSrcExts monadloc syb ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/pepeiborra/monadloc";
    description = "A preprocessor for generating monadic call traces";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tomberek ];
  };
})
