{ cabal, Cabal, convertible, deepseq, doctest, emacs, filepath
, ghcSybUtils, hlint, hspec, ioChoice, syb, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "4.1.2";
  sha256 = "0xdpy61dc56zvpgr2z9cdyd85d65l426vnbfgsw6w494w0bp3sh7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal convertible deepseq filepath ghcSybUtils hlint ioChoice syb
    time transformers
  ];
  testDepends = [
    Cabal convertible deepseq doctest filepath ghcSybUtils hlint hspec
    ioChoice syb time transformers
  ];
  buildTools = [ emacs ];
  doCheck = false;
  configureFlags = "--datasubdir=${self.pname}-${self.version}";
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
