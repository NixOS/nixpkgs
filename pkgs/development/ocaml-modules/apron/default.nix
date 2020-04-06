{ stdenv, fetchFromGitHub, perl, gmp, mpfr, ppl, ocaml, findlib, camlidl, mlgmpidl }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-apron-${version}";
  version = "0.9.12";
  src = fetchFromGitHub {
    owner = "antoinemine";
    repo = "apron";
    rev = "v${version}";
    sha256 = "0bciv4wz52p57q0aggmvixvqrsd1slflfyrm1z6fy5c44f4fmjjn";
  };

  buildInputs = [ perl gmp mpfr ppl ocaml findlib camlidl ];
  propagatedBuildInputs = [ mlgmpidl ];

  prefixKey = "-prefix ";
  preBuild = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs";

  meta = {
    license = stdenv.lib.licenses.lgpl21;
    homepage = http://apron.cri.ensmp.fr/library/;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    description = "Numerical abstract domain library";
    inherit (ocaml.meta) platforms;
  };
}
