{ stdenv, fetchurl }:
 
stdenv.mkDerivation rec {
  name = "libpipeline-1.2.6";
  
  src = fetchurl {
    url = "mirror://savannah/libpipeline/${name}.tar.gz";
    sha256 = "0wjsigim422ilzs46hxzv98l10zprpbk53gq3jzj6s9kn9n1wljc";
  };

  meta = with stdenv.lib; {
    homepage = "http://libpipeline.nongnu.org";
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
