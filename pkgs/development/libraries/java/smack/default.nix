{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "smack-3_0_4";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.igniterealtime.org/downloadServlet?filename=smack/smack_3_0_4.tar.gz;
    sha256 = "075nn7vwfjr2a9j6ycikkbssxhai82vpvll9123r83rar3ds3li6";
  };  
}
