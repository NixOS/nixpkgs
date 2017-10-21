{ stdenv, fetchzip, perl, gmp, mpfr, ppl, ocaml, findlib, camlidl, mlgmpidl }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-apron-${version}";
  version = "20160125";
  src = fetchzip {
    url = "http://apron.gforge.inria.fr/apron-${version}.tar.gz";
    sha256 = "1a7b7b9wsd0gdvm41lgg6ayb85wxc2a3ggcrghy4qiphs4b9v4m4";
  };

  buildInputs = [ perl gmp mpfr ppl ocaml findlib camlidl ];
  propagatedBuildInputs = [ mlgmpidl ];

  prefixKey = "-prefix ";
  createFindlibDestdir = true;

  meta = {
    license = stdenv.lib.licenses.lgpl21;
    homepage = http://apron.cri.ensmp.fr/library/;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    description = "Numerical abstract domain library";
    inherit (ocaml.meta) platforms;
  };
}
