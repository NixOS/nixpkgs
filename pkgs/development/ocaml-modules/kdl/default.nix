{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  menhir,
  menhirLib,
  ppx_expect,
  sexplib0,
  zarith,
}:

buildDunePackage rec {
  pname = "kdl";
  version = "0.2.0";

  minimalOCamlVersion = "4.14";

  nativeBuildInputs = [
    menhir
  ];

  propagatedBuildInputs = [
    menhirLib
    sexplib0
  ];

  checkInputs = [
    ppx_expect
    zarith
  ];

  doCheck = true;

  src = fetchFromGitHub {
    owner = "eilvelia";
    repo = "ocaml-kdl";
    tag = "v${version}";
    hash = "sha256-0MiJe0XbWAlS2NvGxLplsgVfCNaA/7iCMx4+F+6FAtM=";
  };

  meta = {
    description = "OCaml implementation of the KDL Document Language v2";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ toastal ];
    homepage = "https://github.com/eilvelia/ocaml-kdl";
  };
}
