{cabal, regexBase}:

cabal.mkDerivation (self : {
  pname = "regex-posix";
  version = "0.94.2"; # Haskell Platform 2010.2.0.0
  sha256 = "ea0c1ed0ab49ade4dba1eea7a42197652ccb18b7a98c4040e37ba11d26f33067";
  propagatedBuildInputs = [regexBase];
  meta = {
    description = "Replaces/Enhances Text.Regex";
  };
})  

