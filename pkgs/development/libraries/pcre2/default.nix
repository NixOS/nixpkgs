{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pcre2-${version}";
  version = "10.22";
  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${name}.tar.bz2";
    sha256 = "05pl338962d7syd1rbkg96916mq7d3amz1n2fjnm0v5cyhcldd5j";
  };

  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
    "--enable-jit"
  ];

  outputs = [ "bin" "dev" "out" "doc" "man" "devdoc" ];

  postFixup = ''
    moveToOutput bin/pcre2-config "$dev"
  '';

  meta = with stdenv.lib; {
    description = "Perl Compatible Regular Expressions";
    homepage = "http://www.pcre.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.all;
  };
}
