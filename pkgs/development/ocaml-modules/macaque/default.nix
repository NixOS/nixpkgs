{ lib, stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, pgocaml, camlp4 }:

stdenv.mkDerivation rec {
  pname = "ocaml-macaque";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "macaque";
    rev = version;
    sha256 = "sha256-W9ZFaINYYtIikKy/ZqdlKeFQSA7DQT9plc3+ZhlSIJI=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild camlp4 ];
  propagatedBuildInputs = [ pgocaml camlp4 ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = with lib; {
    description = "Macros for Caml Queries";
    homepage = "https://github.com/ocsigen/macaque";
    license = licenses.lgpl2;
    platforms = ocaml.meta.platforms or [ ];
    maintainers = with maintainers; [ vbgl ];
  };
}
