{ stdenv, ocaml, findlib, ocamlbuild, fetchzip
, cppo, ppx_tools, ppx_derivers, result, ounit, ocaml-migrate-parsetree
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "ppx_deriving is not available for OCaml ${ocaml.version}"
else

let param =
  if ocaml.version == "4.03.0"
  then {
    version = "4.1";
    sha256 = "0cy9p8d8cbcxvqyyv8fz2z9ypi121zrgaamdlp4ld9f3jnwz7my9";
    extraPropagatedBuildInputs = [];
  } else {
    version = "4.2.1";
    sha256 = "1yhhjnncbbb7fsif7qplndh01s1xd72dqm8f3jkgx9y4ariqqvf9";
    extraPropagatedBuildInputs = [ ocaml-migrate-parsetree ppx_derivers ];
}; in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ppx_deriving-${version}";
  inherit (param) version;

  src = fetchzip {
    url = "https://github.com/ocaml-ppx/ppx_deriving/archive/v${version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild cppo ounit ];
  propagatedBuildInputs = param.extraPropagatedBuildInputs ++
    [ ppx_tools result ];

  createFindlibDestdir = true;

  installPhase = "OCAMLPATH=$OCAMLPATH:`ocamlfind printconf destdir` make install";

  meta = with stdenv.lib; {
    description = "deriving is a library simplifying type-driven code generation on OCaml >=4.02.";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
