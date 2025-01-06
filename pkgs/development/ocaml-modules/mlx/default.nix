{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ppxlib,
  menhir,
  ocaml,
}:

let
  pname = "mlx";
  version = "0.9";
in
lib.throwIf (lib.versionAtLeast ocaml.version "5.3")
  "${pname}-${version} is not available for OCaml ${ocaml.version}"
  buildDunePackage
  {
    inherit pname version;

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
