{ cabal, Cabal, convertible, doctest, emacs, filepath, ghcSybUtils
, hlint, hspec, ioChoice, syb, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "4.0.1";
  sha256 = "13dgphwspp91bycnmcxgxzv4470wpjv5zfswwgmad644i77nixmm";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal convertible filepath ghcSybUtils hlint ioChoice syb time
    transformers
  ];
  testDepends = [
    Cabal convertible doctest filepath ghcSybUtils hlint hspec ioChoice
    syb time transformers
  ];
  buildTools = [ emacs ];
  postInstall = ''
    cd $out/share/$pname-$version
    make
    rm Makefile
    cd ..
    ensureDir "$out/share/emacs"
    mv $pname-$version emacs/site-lisp
    mv $out/bin/ghc-mod $out/bin/.ghc-mod-wrapped
    cat - > $out/bin/ghc-mod <<EOF
    #! ${self.stdenv.shell}
    COMMAND=\$1
    shift
    eval exec $out/bin/.ghc-mod-wrapped \$COMMAND \$( ${self.ghc.GHCGetPackages} ${self.ghc.version} | tr " " "\n" | tail -n +2 | paste -d " " - - | sed 's/.*/-g "&"/' | tr "\n" " ") "\$@"
    EOF
    chmod +x $out/bin/ghc-mod
  '';
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/ghc-mod/";
    description = "Happy Haskell Programming";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.bluescreen303
      self.stdenv.lib.maintainers.ocharles
    ];
  };
})
