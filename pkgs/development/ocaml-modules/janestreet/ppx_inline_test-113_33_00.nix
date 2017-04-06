{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_tools, ppx_driver
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_inline_test-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_inline_test-113.33.00+4.03.tar.gz;
    sha256 = "1sw71wnwznia1spicilj4bzspgdk1dhp0j4hp57a9xmsscg44i4k";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ ppx_driver ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
