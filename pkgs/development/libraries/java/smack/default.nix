{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "smack-3_1_0";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.igniterealtime.org/downloadServlet?filename=smack/smack_3_1_0.tar.gz;
    sha256 = "02kn3i7py6ilnchz0yn4v2g0sh8msxcw61kankqrz2a65852i28i";
  };  
}
