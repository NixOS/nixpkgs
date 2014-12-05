{ autoconf, automake, fetchgit, libtool, stdenv, openssl }:

let version = "1.5"; in

stdenv.mkDerivation {
  name = "libetpan-${version}";

  meta = with stdenv.lib; {
    description = "An efficient, portable library for different kinds of mail access: IMAP, SMTP, POP, and NNTP";
    homepage = http://www.etpan.org/libetpan.html;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };

  src = fetchgit {
    url = "git://github.com/dinhviethoa/libetpan";
    rev = "refs/tags/" + version;
    sha256 = "bf9465121a0fb09418215ee3474a400ea5bc5ed05a6811a2978afe4905e140c9";
  };

  buildInputs = [ autoconf automake libtool openssl ];

  configureScript = "./autogen.sh";
}
