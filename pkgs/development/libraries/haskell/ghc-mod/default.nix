{ cabal, Cabal, convertible, emacs, filepath, ghcPaths, ghcSybUtils
, hlint, ioChoice, regexPosix, syb, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "1.11.4";
  sha256 = "1bxmpvad415ayzwyijjm0zsck0z8aa1nfjixwb6l80i6lbxi4rfg";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal convertible filepath ghcPaths ghcSybUtils hlint ioChoice
    regexPosix syb time transformers
  ];
  buildTools = [ emacs ];
  postInstall = ''
      cd $out/share/$pname-$version
      make
      rm Makefile
      cd ..
      ensureDir "$out/share/emacs"
      mv $pname-$version emacs/site-lisp
    '';
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/ghc-mod/";
    description = "Happy Haskell programming on Emacs/Vim";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.bluescreen303
    ];
  };
})
