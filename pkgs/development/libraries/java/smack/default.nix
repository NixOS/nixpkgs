{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "smack-4.1.9";
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://www.igniterealtime.org/downloadServlet?filename=smack/smack_4_1_9.tar.gz";
    sha256 = "009x0qcxd4dkvwcjz2nla470pwbabwvg37wc21pslpw42ldi0bzp";
  };

  meta = {
    description = "A XMPP (Jabber) client library for instant messaging and presence";
    homepage = "http://www.igniterealtime.org/projects/smack/";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.asl20;
  };
}
