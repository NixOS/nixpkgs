{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_tools, ppx_here
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_fail-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_fail-113.33.00+4.03.tar.gz;
    sha256 = "1fy1aqsylf6yk527w13rm2b20il9vy026c5ww65pj3ks5zykfvx9";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ ppx_here ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
