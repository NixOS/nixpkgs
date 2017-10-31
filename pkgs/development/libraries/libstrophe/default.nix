{ stdenv, fetchFromGitHub, automake, autoconf, libtool, openssl, expat, pkgconfig, check }:

stdenv.mkDerivation rec {
  name = "libstrophe-${version}";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "strophe";
    repo = "libstrophe";
    rev = version;
    sha256 = "099iv13c03y1dsn2ngdhfx2cnax0aj2gfh00w55hlzpvmjm8dsml";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ automake autoconf openssl expat libtool check ];

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
    homepage = http://strophe.im/libstrophe/;
    license = with stdenv.lib.licenses; [gpl3 mit];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [devhell flosse];
  };
}
