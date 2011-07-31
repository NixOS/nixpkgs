{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "mtlparse";
  version = "0.1.2";
  sha256 = "cd85d985e4eff842b1c053a2ff507094a20995c5757acc06ea34ff07d9edd142";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "parse library based on the mtl package";
  };
})

