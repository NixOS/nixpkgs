{ stdenv
, fetchFromGitHub
, pkg-config
, automake
, autoconf
, libtool
, openssl
, expat
, check
}:

stdenv.mkDerivation rec {
  pname = "libstrophe";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "strophe";
    repo = pname;
    rev = version;
    sha256 = "sha256-6byg7hE0DN/cbf9NHpK/2DhXZyuelYAp+SA7vVUgo4U=";
  };

  nativeBuildInputs = [ automake autoconf pkg-config libtool check ];
  buildInputs = [ openssl expat ];

  dontDisableStatic = true;

  preConfigure = "mkdir m4 && sh bootstrap.sh";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A simple, lightweight C library for writing XMPP clients";
    longDescription = ''
      libstrophe is a lightweight XMPP client library written in C. It has
      minimal dependencies and is configurable for various environments. It
      runs well on both Linux, Unix, and Windows based platforms.
    '';
    homepage = "https://strophe.im/libstrophe/";
    license = with licenses; [ gpl3 mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ devhell flosse ];
  };
}
