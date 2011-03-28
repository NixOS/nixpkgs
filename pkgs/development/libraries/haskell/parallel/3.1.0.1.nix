{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "parallel";
  version = "3.1.0.1"; # Haskell Platform 2011.2.0.0
  sha256 = "0j03i5467iyz98fl4fnzlwrr93j2as733kbrxnlcgyh455kb89ns";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "parallel programming library";
  };
})

