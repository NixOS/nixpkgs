{ stdenv, fetchFromGitHub, perl, ocaml, findlib, camlidl, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-mlgmpidl-${version}";
  version = "1.2.11";
  src = fetchFromGitHub {
    owner = "nberth";
    repo = "mlgmpidl";
    rev = version;
    sha256 = "1rycl84sdvgb5avdsya9iz8brx92y2zcb6cn4w1j0164j6q2ril9";
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
  '';

  createFindlibDestdir = true;

  meta = {
    description = "OCaml interface to the GMP library";
    homepage = https://www.inrialpes.fr/pop-art/people/bjeannet/mlxxxidl-forge/mlgmpidl/;
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
