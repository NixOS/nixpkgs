{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, libtool, openssl, expat, pkgconfig, check }:

stdenv.mkDerivation rec {
  pname = "libmesode";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "boothj5";
    repo = "libmesode";
    rev = version;
    sha256 = "0xzfg1xx88cn36352nnjlb1p7xyw32yqkhjzq10px88iaaqz1vv0";
  };

  patches = [
    (fetchpatch {
      name = "fix-ssl-certificate-verification.diff";
      url = "https://github.com/profanity-im/libmesode/commit/532ed1e9d3e71e5bea0752e03dbacd4139d750d1.diff";
      sha256 = "140jp7xzskik0sb6aqjsw7z477a124cxl7dkm80m2nyzjng4pzg5";
    })
  ];

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
    homepage = "https://github.com/boothj5/libmesode/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
