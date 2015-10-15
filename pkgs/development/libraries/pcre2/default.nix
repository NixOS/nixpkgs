{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "pcre2-10.20";
  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.20.tar.bz2";
    sha256 = "0yj8mm9ll9zj3v47rvmmqmr1ybxk72rr2lym3rymdsf905qjhbik";
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
