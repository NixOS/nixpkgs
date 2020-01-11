{ stdenv, fetchFromGitHub, automake, autoconf, libtool, openssl, expat, pkgconfig, check }:

stdenv.mkDerivation rec {
  pname = "libstrophe";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "strophe";
    repo = pname;
    rev = version;
    sha256 = "1g1l0w9z9hdy5ncdvd9097gi7k7783did6py5h9camlpb2fnk5mk";
  };

  nativeBuildInputs = [ automake autoconf pkgconfig libtool check ];
  buildInputs = [ openssl expat ];

  dontDisableStatic = true;

  preConfigure = "mkdir m4 && sh bootstrap.sh";

  doCheck = true;

  meta = {
    description = "A simple, lightweight C library for writing XMPP clients";
    longDescription = ''
      libstrophe is a lightweight XMPP client library written in C. It has
      minimal dependencies and is configurable for various environments. It
      runs well on both Linux, Unix, and Windows based platforms.
    '';
    homepage = "http://strophe.im/libstrophe/";
    license = with stdenv.lib.licenses; [ gpl3 mit ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ devhell flosse ];
  };
}
