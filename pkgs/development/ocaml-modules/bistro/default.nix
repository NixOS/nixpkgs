{ lib
, ocaml
, fetchFromGitHub
, buildDunePackage
, base64
, bos
, core
, lwt_react
, ocamlgraph
, ppx_sexp_conv
, rresult
, sexplib
, tyxml
}:

buildDunePackage rec {
  pname = "bistro";
  version = "unstable-2021-07-13";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "4ce8d98f34f15ebf63ececccc9c763fec2b5fa6d";
    sha256 = "sha256:16vxcdsj4dmswgm6igshs3hirz8jrg8l5b2xgcnxxgvsrc9sxljs";
  };

  # Fix build with ppxlib 0.23
  postPatch = ''
    substituteInPlace ppx/bistro_script.ml \
      --replace 'Parser.parse_expression' 'Ocaml_common.Parser.parse_expression'
  '';

  propagatedBuildInputs = [
    base64 bos core lwt_react ocamlgraph ppx_sexp_conv rresult sexplib tyxml
  ];

  minimalOCamlVersion = "4.12";

  meta = {
    inherit (src.meta) homepage;
    description = "Build and execute typed scientific workflows";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.gpl2;
    # ppx-related build failure; see https://github.com/pveber/bistro/issues/49:
    broken = lib.versionAtLeast ocaml.version "4.13";
  };
}
