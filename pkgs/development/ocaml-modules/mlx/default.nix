{
  lib,
  fetchFromGitHub,
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
