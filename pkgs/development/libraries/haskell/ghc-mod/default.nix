{ cabal, attoparsec, attoparsecEnumerator, ghcPaths, hlint, regexPosix, emacsPackages }:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "1.10.5";
  sha256 = "0hbimrrlasa2rkmdz9d4fcyk70fynmwx0zqyl470hrwz8d8v73rc";
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
