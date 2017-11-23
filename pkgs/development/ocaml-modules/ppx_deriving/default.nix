{ stdenv, buildOcaml, ocaml, fetchzip
, cppo, ppx_tools, ppx_derivers, result, ounit, ocaml-migrate-parsetree
}:

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

buildOcaml rec {
  name = "ppx_deriving";
  inherit (param) version;

  minimumSupportedOcamlVersion = "4.02";

  src = fetchzip {
    url = "https://github.com/whitequark/${name}/archive/v${version}.tar.gz";
    inherit (param) sha256;
  };

  hasSharedObjects = true;

  buildInputs = [ cppo ounit ];
  propagatedBuildInputs = param.extraPropagatedBuildInputs ++
    [ ppx_tools result ];

  installPhase = "OCAMLPATH=$OCAMLPATH:`ocamlfind printconf destdir` make install";

  meta = with stdenv.lib; {
    description = "deriving is a library simplifying type-driven code generation on OCaml >=4.02.";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
