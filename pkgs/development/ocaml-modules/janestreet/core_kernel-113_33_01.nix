{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, ppx_jane
, bin_prot, fieldslib, typerep, variantslib
, ppx_assert, ppx_bench, ppx_expect, ppx_inline_test
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-core_kernel-113.33.01+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/core_kernel-113.33.01+4.03.tar.gz;
    sha256 = "0ra2frspqjqk1wbb58lrb0anrgsyhja00zsybka85qy71lblamfs";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_jane ];
  propagatedBuildInputs = [
    bin_prot fieldslib typerep variantslib
    ppx_assert ppx_bench ppx_expect ppx_inline_test
  ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
