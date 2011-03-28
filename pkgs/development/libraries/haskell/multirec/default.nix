{cabal}:

cabal.mkDerivation (self : {
  pname = "multirec";
  version = "0.5";
  sha256 = "1nrfbiy5g51cpaqqi1adrr32x74wjjvplyyrphvzf4rxhnhj3xpw";
  noHaddock = true; # don't know why Haddock causes an error
  meta = {
    description = "Generic programming with systems of recursive datatypes";
  };
})

