{ cabal, attoparsec, attoparsecEnumerator, ghcPaths, hlint, regexPosix, emacsPackages }:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "1.0.6";
  sha256 = "c075314de03209827a0e59ee3e63a4d21bc8edb024a1e36721eea248805b38ba";
  buildDepends = [
    attoparsec attoparsecEnumerator ghcPaths hlint regexPosix
  ];
  propagatedBuildInputs = [emacsPackages.emacs emacsPackages.haskellMode];
  isExecutable = true;
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
    description = "Happy Haskell programming on Emacs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.bluescreen303
      self.stdenv.lib.maintainers.simons
    ];
  };
})
