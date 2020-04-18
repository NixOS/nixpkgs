{ stdenv, fetchFromGitHub
, autoconf
, automake
, libtool
, openssl
}:

stdenv.mkDerivation rec {
  pname = "libetpan";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "dinhviethoa";
    repo = "libetpan";
    rev = version;
    sha256 = "19g4qskg71jv7sxfxsdkjmrxk9mk5kf9b6fhw06g6wvm3205n95f";
  };

  nativeBuildInputs = [ libtool autoconf automake ];

  buildInputs = [ openssl ];

  configureScript = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "An efficient, portable library for different kinds of mail access: IMAP, SMTP, POP, and NNTP";
    homepage = "http://www.etpan.org/libetpan.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
