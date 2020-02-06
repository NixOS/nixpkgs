{ stdenv, fetchFromGitHub, perl, ocaml, findlib, camlidl, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-mlgmpidl-${version}";
  version = "1.2.12";
  src = fetchFromGitHub {
    owner = "nberth";
    repo = "mlgmpidl";
    rev = version;
    sha256 = "17xqiclaqs4hmnb92p9z6z9a1xfr31vcn8nlnj8ykk57by31vfza";
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
    homepage = https://www.inrialpes.fr/pop-art/people/bjeannet/mlxxxidl-forge/mlgmpidl/;
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
