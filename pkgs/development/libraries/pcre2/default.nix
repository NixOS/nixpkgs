{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pcre2-10.21";
  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${name}.tar.bz2";
    sha256 = "1q6lrj9b08l1q39vxipb0fi88x6ybvkr6439h8bjb9r8jd81fsn6";
  };

  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
    "--enable-jit"
  ];

  meta = {
	description = "Perl Compatible Regular Expressions";
    homepage = "http://www.pcre.org/";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.all;
  };
}
