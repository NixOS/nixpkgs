{
  lib,
  factorPackages,
  fetchFromGitHub,
  curl,
  gnutls,
}:

factorPackages.buildFactorVocab {
  pname = "bresenham";
  version = "dev";

  src = fetchFromGitHub {
    owner = "Capital-EX";
    repo = "bresenham";
    rev = "58d76b31a17f547e19597a09d02d46a742bf6808";
    hash = "sha256-cfQOlB877sofxo29ahlRHVpN3wYTUc/rFr9CJ89dsME=";
  };

  meta = {
    description = "Bresenham's line interpolation algorithm";
    homepage = "https://github.com/Capital-EX/bresenham";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ spacefrogg ];
  };
}
