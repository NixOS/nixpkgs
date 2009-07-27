{cabal, ncurses, extensibleExceptions}:

cabal.mkDerivation (self : {
  pname = "terminfo";
  version = "0.3.0.2";
  sha256 = "2303d934fcec0f6413f15887f7f42e8e2e5b27812534a929bf585bfa6f3a9229";
  propagatedBuildInputs = [ncurses extensibleExceptions];
  meta = {
    description = "Haskell bindings for the terminfo library";
  };
})
