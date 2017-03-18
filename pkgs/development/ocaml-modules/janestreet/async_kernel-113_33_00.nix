{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, core_kernel, ppx_jane
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-async_kernel-113.33.00";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/async_kernel-113.33.00.tar.gz;
    sha256 = "1kkkqpdd3mq9jh3b3l1yk37841973lh6g3pfv8fcjzif4n7myf15";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_jane ];
  propagatedBuildInputs = [ core_kernel ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
