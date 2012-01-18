{ cabal, attoparsec, attoparsecEnumerator, ghcPaths, hlint, regexPosix, emacs, emacs23Packages }:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "1.0.6";
  sha256 = "c075314de03209827a0e59ee3e63a4d21bc8edb024a1e36721eea248805b38ba";
  buildDepends = [
    attoparsec attoparsecEnumerator ghcPaths hlint regexPosix
  ];
#  buildTools = [emacs emacs23];
  propagatedBuildInputs = [emacs emacs23Packages.haskellMode];
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
    description = "Happy Haskell programming on Emacs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.bluescreen303
    ];
  };
})
