{ stdenv, buildOcaml, ocaml, fetchzip
, cppo, ppx_tools, ppx_derivers, result, ounit, ocaml-migrate-parsetree
}:

buildOcaml rec {
  name = "ppx_deriving";
  version = "4.2";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchzip {
    url = "https://github.com/whitequark/${name}/archive/v${version}.tar.gz";
    sha256 = "0scsg45wp6xdqj648fz155r4yngyl2xcd3hdszfzqwdpbax33914";
  };

  hasSharedObjects = true;

  buildInputs = [ cppo ounit ];
  propagatedBuildInputs =
    [ ppx_tools ppx_derivers result ocaml-migrate-parsetree ];

  installPhase = "OCAMLPATH=$OCAMLPATH:`ocamlfind printconf destdir` make install";

  meta = with stdenv.lib; {
    description = "deriving is a library simplifying type-driven code generation on OCaml >=4.02.";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
