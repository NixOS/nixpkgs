{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_driver
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_let-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_let-113.33.00+4.03.tar.gz;
    sha256 = "012yzayknm9qv8ap9rbwf4fwnmx935mfy7c75ifagbnfl4lh7dmp";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];
  propagatedBuildInputs = [ ppx_driver ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
