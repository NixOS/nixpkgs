{ stdenv, fetchFromGitHub, automake, autoconf, libtool, openssl, expat, pkgconfig, check }:

stdenv.mkDerivation rec {
  name = "libstrophe-${version}";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "strophe";
    repo = "libstrophe";
    rev = version;
    sha256 = "1iic8xbcxh21dzns8m9kkz0cj5f3ppn414gnhyh4y2wcjsz6hp8l";
  };

  buildInputs = [ automake autoconf openssl expat libtool pkgconfig check ];

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
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
