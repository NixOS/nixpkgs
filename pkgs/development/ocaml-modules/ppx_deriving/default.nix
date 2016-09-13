{stdenv, buildOcaml, fetchurl,
 cppo, ppx_tools, result, ounit}:

buildOcaml rec {
  name = "ppx_deriving";
  version = "v3.3";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/whitequark/${name}/archive/${version}.tar.gz";
    sha256 = "1j20c6r2v7h05a4v9m8z5m1yqgwif41yrp63mik14pf3dkrj8x3f";
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
