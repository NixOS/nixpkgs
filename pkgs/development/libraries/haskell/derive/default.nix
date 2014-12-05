{ cabal, process, filepath, haskellSrcExts, syb, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "derive";
  version = "2.5.18";
  sha256 = "1jqng8v1d4rac8xmrpm7h1pkyr9pfwsbb0ap6pnwzpwz9fns9c3k";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    process filepath haskellSrcExts syb transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/derive/";
    description = "A program and library to derive instances for data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
