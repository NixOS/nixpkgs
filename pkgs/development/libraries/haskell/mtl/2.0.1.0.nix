{cabal, transformers}:

cabal.mkDerivation (self : {
  pname = "mtl";
  version = "2.0.1.0"; # Haskell Platform 2011.2.0.0
  sha256 = "1w6jpzyl08mringnd6gxwcl3y9q506r240vm1sv0aacml1hy8szk";
  propagatedBuildInputs = [transformers];
  meta = {
    description = "Monad transformer library";
  };
})  

