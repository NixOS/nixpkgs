{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, async_kernel, core, ppx_jane
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-async_unix-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/async_unix-113.33.00+4.03.tar.gz;
    sha256 = "12b0ffq9yhv3f49kk2k7z7hrn2j4xlka7knm99hczl6gmjni7nqv";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_jane ];
  propagatedBuildInputs = [ async_kernel core ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
