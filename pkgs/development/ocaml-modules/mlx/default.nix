{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildDunePackage,
  ppxlib,
  menhir,
}:

buildDunePackage rec {
  pname = "mlx";
  version = "0.9";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "ocaml-mlx";
    repo = "mlx";
    rev = version;
    hash = "sha256-3hPtyBKD2dp4UJBykOudW6KR2KXPnBuDnuJ1UNLpAp0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ocaml-mlx/mlx/commit/01771e2a8b45f4f70cfd93533af2af9ed4a28a7e.patch";
      hash = "sha256-czA2sIORmunIeaHn7kpcuv0y97uJhe6aUEMj/QHEag4=";
    })
  ];

  buildInputs = [
    ppxlib
    menhir
  ];

  meta = with lib; {
    description = "OCaml syntax dialect which adds JSX syntax expressions";
    homepage = "https://github.com/ocaml-mlx/mlx";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ Denommus ];
  };
}
