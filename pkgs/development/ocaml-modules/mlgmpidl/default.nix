{ stdenv, lib, fetchFromGitHub, perl, ocaml, findlib, camlidl, gmp, mpfr }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-mlgmpidl";
  version = "1.2.12";
  src = fetchFromGitHub {
    owner = "nberth";
    repo = "mlgmpidl";
    rev = version;
    sha256 = "17xqiclaqs4hmnb92p9z6z9a1xfr31vcn8nlnj8ykk57by31vfza";
  };

  nativeBuildInputs = [ perl ocaml findlib mpfr camlidl ];
  buildInputs = [ gmp mpfr ];

  strictDeps = true;

  prefixKey = "-prefix ";
  configureFlags = [
    "--gmp-prefix ${gmp.dev}"
    "--mpfr-prefix ${mpfr.dev}"
  ];

  postConfigure = ''
    sed -i Makefile \
      -e 's|/bin/rm|rm|'
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
