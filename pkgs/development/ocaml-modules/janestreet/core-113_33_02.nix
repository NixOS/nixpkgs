{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_jane, core_kernel
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-core-113.33.02+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/core-113.33.02+4.03.tar.gz;
    sha256 = "1gvd5saa0sdgyv9w09imqlkw0c21v2ixic8fxx14jxrwck0zn4bc";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_jane ];
  propagatedBuildInputs = [ core_kernel ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
