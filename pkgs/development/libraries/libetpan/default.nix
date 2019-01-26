{ autoconf, automake, fetchgit, libtool, stdenv, openssl }:

let version = "1.8"; in

stdenv.mkDerivation {
  name = "libetpan-${version}";

  src = fetchgit {
    url = "git://github.com/dinhviethoa/libetpan";
    rev = "refs/tags/" + version;
    sha256 = "09xqy1n18qn63x7idfrpwm59lfkvb1p5vxkyksywvy4f6mn4pyxk";
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
