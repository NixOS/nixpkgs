{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "glog-0.3.3";
  
  src = fetchurl {
    url = "http://google-glog.googlecode.com/files/${name}.tar.gz";
    sha1 = "ed40c26ecffc5ad47c618684415799ebaaa30d65";
  };

  meta = {
    homepage = http://code.google.com/p/google-glog/;
    license = stdenv.lib.licenses.bsd3;
    description = "Library for application-level logging";
  };
}
