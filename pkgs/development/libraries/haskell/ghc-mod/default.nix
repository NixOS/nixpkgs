{ cabal, Cabal, convertible, emacs, filepath, ghcPaths, ghcSybUtils
, hlint, ioChoice, regexPosix, syb, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "1.11.3";
  sha256 = "13r3cz25lf0ndsyfc5adqx5mdv7hcl3qp7n2syg2msrn133xpwb2";
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
