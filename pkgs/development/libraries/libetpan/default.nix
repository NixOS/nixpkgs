{ autoconf, automake, fetchgit, libtool, stdenv, openssl }:

let version = "1.6"; in

stdenv.mkDerivation {
  name = "libetpan-${version}";

  src = fetchgit {
    url = "git://github.com/dinhviethoa/libetpan";
    rev = "refs/tags/" + version;
    sha256 = "12n0vd0bwdyjcmwmpv1hdq5l04mqy6qfyy8mhsblddqaa1ah9qy8";
  };

  buildInputs = [ autoconf automake libtool openssl ];

  configureScript = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "An efficient, portable library for different kinds of mail access: IMAP, SMTP, POP, and NNTP";
    homepage = http://www.etpan.org/libetpan.html;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
