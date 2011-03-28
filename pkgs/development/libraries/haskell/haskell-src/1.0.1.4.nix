{cabal, happy, syb}:

cabal.mkDerivation (self : {
  pname = "haskell-src";
  version = "1.0.1.4"; # Haskell Platform 2011.2.0.0
  sha256 = "02h33d7970641p9vi62sgcxb5v4yaz8xx9vf2yxyvxs3hglm7f0j";
  extraBuildInputs = [happy];
  propagatedBuildInputs = [syb];
  meta = {
    description = "Manipulating Haskell source code";
  };
})

