{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libantlr3c-3.4";
  src = fetchurl {
    url = http://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz;
    sha256 ="0lpbnb4dq4azmsvlhp6khq1gy42kyqyjv8gww74g5lm2y6blm4fa";
  };

  configureFlags = if stdenv.is64bit then "--enable-64bit" else "";

  meta = with stdenv.lib; {
    description = "C runtime libraries of ANTLR v3";
    homepage = http://www.antlr3.org/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vbgl ];
  };
}
