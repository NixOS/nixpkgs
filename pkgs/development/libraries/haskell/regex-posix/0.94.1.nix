{cabal, regexBase}:

cabal.mkDerivation (self : {
  pname = "regex-posix";
  version = "0.94.1"; # Haskell Platform 2010.1.0.0
  sha256 = "63e76de0610d35f1b576ae65a25a38e04e758ed64b9b3512de95bdffd649485c";
  propagatedBuildInputs = [regexBase];
  meta = {
    description = "Replaces/Enhances Text.Regex";
  };
})  

