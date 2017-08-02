{ stdenv, fetchFromGitHub, autoreconfHook, libtool, openssl, expat, pkgconfig, check }:

stdenv.mkDerivation rec {
  name = "libmesode-${version}";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "boothj5";
    repo = "libmesode";
    rev = version;
    sha256 = "1zb1x422zkpnxrz9d2b7pmi8ms60lbw49yh78mydqfypsmj2iyfh";
  };

  buildInputs = [ autoreconfHook openssl expat libtool pkgconfig check ];

  dontDisableStatic = true;

  doCheck = true;

  meta = {
    description = "Fork of libstrophe (https://github.com/strophe/libstrophe) for use with Profanity XMPP Client";
    longDescription = ''
      Reasons for forking:

      - Remove Windows support
      - Support only one XML Parser implementation (expat)
      - Support only one SSL implementation (OpenSSL)

      This simplifies maintenance of the library when used in Profanity.
      Whilst Profanity will run against libstrophe, libmesode provides extra
      TLS functionality such as manual SSL certificate verification.
    '';
    homepage = https://github.com/boothj5/libmesode/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
