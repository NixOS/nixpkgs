{ cabal, Cabal, convertible, doctest, emacs, filepath, ghcPaths
, ghcSybUtils, hlint, hspec, ioChoice, syb, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "3.1.3";
  sha256 = "0g12cj8yn2znhqi7wiz5jayzh4g5jdcj1qwy5g3pz456hcpb0jig";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal convertible filepath ghcPaths ghcSybUtils hlint ioChoice syb
    time transformers
  ];
  testDepends = [
    Cabal convertible doctest filepath ghcPaths ghcSybUtils hlint hspec
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
    mv $out/bin/ghc-mod $out/ghc-mod
    cat - > $out/bin/ghc-mod <<EOF
    #!/bin/sh
    COMMAND=\$1
    shift
    eval exec $out/ghc-mod \$COMMAND \$( ${self.ghc.GHCGetPackages} ${self.ghc.ghcVersion} | tr " " "\n" | tail -n +2 | paste -d " " - - | sed 's/.*/-g "&"/' | tr "\n" " ") "\$@"
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
