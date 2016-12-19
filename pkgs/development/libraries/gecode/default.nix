{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "4.4.0";

  src = fetchurl {
    url = "http://www.gecode.org/download/${name}.tar.gz";
    sha256 = "0akqjzy6pd229mn0lhpdbyc4wbazhprkd5ijqs99z68bj3b9h0s3";
  };

  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = http://www.gecode.org;
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ maintainers.manveru ];
  };
}
