{ stdenv, lib, fetchFromGitHub, perl, ocaml, findlib, camlidl, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-mlgmpidl-${version}";
  version = "1.2.14";
  src = fetchFromGitHub {
    owner = "nberth";
    repo = "mlgmpidl";
    rev = version;
    sha256 = "sha256-11oO/WUXhkhju94T5qWegpcQEIAqSLiESZFcX8t4PPM=";
  };

  buildInputs = [ perl gmp mpfr ocaml findlib camlidl ];

  prefixKey = "-prefix ";
  configureFlags = [
    "--gmp-prefix ${gmp.dev}"
    "--mpfr-prefix ${mpfr.dev}"
  ];

  postConfigure = ''
    sed -i Makefile \
      -e 's|^	/bin/rm |	rm |'
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';


  meta = {
    description = "OCaml interface to the GMP library";
    homepage = "https://www.inrialpes.fr/pop-art/people/bjeannet/mlxxxidl-forge/mlgmpidl/";
    license = lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
