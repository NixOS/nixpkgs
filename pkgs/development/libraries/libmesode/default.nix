{ stdenv, fetchFromGitHub, autoreconfHook, libtool, openssl, expat, pkgconfig, check }:

stdenv.mkDerivation rec {
  pname = "libmesode";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "boothj5";
    repo = "libmesode";
    rev = version;
    sha256 = "06f5nfaypvxrbsinxa1k2vrxrs7kqmg38g4wwwk5d63hpn1pj8ak";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ openssl expat libtool check ];

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
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
