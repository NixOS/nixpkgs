{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "MonadRandom";
  version = "0.1.3";
  sha256 = "be4dd46a93b59a5e94b58e6986934ca91feace9962a1741b6107a3dd06879fea";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Random-number generation monad";
  };
})

