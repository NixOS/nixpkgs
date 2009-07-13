{cabal, binary}:

cabal.mkDerivation (self : {
  pname = "SHA";
  version = "1.4.0";
  sha256 = "7f08042fddadd8e3795d627a042d1884b33e066ab67d03b6de92551a4ad9fc7d";
  propagatedBuildInputs = [binary];
  meta = {
    description = "Implementations of the SHA suite of message digest functions";
  };
})  

