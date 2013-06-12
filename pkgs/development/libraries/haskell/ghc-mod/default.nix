{ cabal, Cabal, convertible, emacs, filepath, ghcPaths, ghcSybUtils
, hlint, hspec, ioChoice, syb, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "2.0.3";
  sha256 = "0f0n4cqpspad3ygw89rp8wj1gxb7mv5zrd8938zm1rn2mimihggr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal convertible filepath ghcPaths ghcSybUtils hlint ioChoice syb
    time transformers
  ];
  testDepends = [
    Cabal convertible filepath ghcPaths ghcSybUtils hlint hspec
    ioChoice syb time transformers
  ];
  buildTools = [ emacs ];
  doCheck = false;
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
    description = "Happy Haskell Programming";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.bluescreen303
    ];
  };
})
