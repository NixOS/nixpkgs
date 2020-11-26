{ stdenv, fetchFromGitHub, perl, gmp, mpfr, ppl, ocaml, findlib, camlidl, mlgmpidl }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-apron-${version}";
  version = "0.9.13";
  src = fetchFromGitHub {
    owner = "antoinemine";
    repo = "apron";
    rev = "v${version}";
    sha256 = "14ymjahqdxj26da8wik9d5dzlxn81b3z1iggdl7rn2nn06jy7lvy";
  };

  buildInputs = [ perl gmp mpfr ppl ocaml findlib camlidl ];
  propagatedBuildInputs = [ mlgmpidl ];

  prefixKey = "-prefix ";
  preBuild = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs";

  meta = {
    license = stdenv.lib.licenses.lgpl21;
    homepage = "http://apron.cri.ensmp.fr/library/";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    description = "Numerical abstract domain library";
    inherit (ocaml.meta) platforms;
  };
}
