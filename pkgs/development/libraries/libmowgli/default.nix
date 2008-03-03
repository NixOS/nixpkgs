{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmowgli-0.6.1";
  
  src = fetchurl {
    url = http://distfiles.atheme.org/libmowgli-0.6.1.tgz;
    sha256 = "0bhxgyx6c913pyiib768qmsi059dnq1zj3k2nik9976hy5yd8m0l";
  };
  
  meta = {
    description = "A development framework for C providing high performance and highly flexible algorithms";
    homepage = http://www.atheme.org/projects/mowgli.shtml;
  };
}
