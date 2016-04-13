{stdenv, fetchurl, ruby }:

stdenv.mkDerivation rec {
  name = "ocl-icd-2.2.9";

  src = fetchurl {
    url = "https://forge.imag.fr/frs/download.php/716/${name}.tar.gz";
    sha256 = "1rgaixwnxmrq2aq4kcdvs0yx7i6krakarya9vqs7qwsv5hzc32hc";
  };

  buildInputs = [ ruby ];

  meta = with stdenv.lib; {
    description = "OpenCL ICD Loader";
    homepage    = https://forge.imag.fr/projects/ocl-icd/;
    license     = licenses.bsd2;
  };
}
