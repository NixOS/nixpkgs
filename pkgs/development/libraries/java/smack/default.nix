{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "smack-3_0_4";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.igniterealtime.org/downloadServlet?filename=smack/smack_3_0_4.tar.gz;
    md5 = "a7eb7df35ed8ab959badd370f995c671";
  };  
}
