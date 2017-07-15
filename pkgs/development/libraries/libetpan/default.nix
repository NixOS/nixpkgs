{ autoconf, automake, fetchFromGitHub, libtool, stdenv, openssl }:

let version = "1.6"; in

stdenv.mkDerivation {
  name = "libetpan-${version}";

  src = fetchFromGitHub {
    owner = "dinhviethoa";
    repo = "libetpan";
    rev = "refs/tags/${version}";
    sha256 = "13hv49271rr9yj7ifxqqmc0jfy1f26llivhp22s5wigick7qjxky";
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
