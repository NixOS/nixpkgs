{ stdenv, buildOcaml, fetchzip
, cppo, ppx_tools, result, ounit
}:

buildOcaml rec {
  name = "ppx_deriving";
  version = "4.1";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchzip {
    url = "https://github.com/whitequark/${name}/archive/v${version}.tar.gz";
    sha256 = "0cy9p8d8cbcxvqyyv8fz2z9ypi121zrgaamdlp4ld9f3jnwz7my9";
  };

  hasSharedObjects = true;

  buildInputs = [ cppo ounit ];
  propagatedBuildInputs =
    [ ppx_tools result ];

  installPhase = "OCAMLPATH=$OCAMLPATH:`ocamlfind printconf destdir` make install";

  meta = with stdenv.lib; {
    description = "deriving is a library simplifying type-driven code generation on OCaml >=4.02.";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
