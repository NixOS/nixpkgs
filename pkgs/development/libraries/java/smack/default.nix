{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "smack-3.4.1";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.igniterealtime.org/downloadServlet?filename=smack/smack_3_4_1.tar.gz;
    sha256 = "13jm93b0dsfxr62brq1hagi9fqk7ip3pi80svq10zh5kcpk77jf4";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
