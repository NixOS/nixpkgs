{
  lib,
  fetchFromGitLab,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "fix";
  version = "20250428";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = "fix";
    rev = version;
    sha256 = "sha256-ZfIKx0BMhnmrqmfyqRi9ElZN1xdkupsDmfRg1GD3l/Q=";
  };

  minimalOCamlVersion = "4.03";
  useDune2 = true;

  meta = with lib; {
    homepage = "https://gitlab.inria.fr/fpottier/fix/";
    description = "Simple OCaml module for computing the least solution of a system of monotone equations";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ vbgl ];
  };
}
