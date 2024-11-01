{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, libtool
, openssl
, expat
, pkg-config
, check
}:

stdenv.mkDerivation rec {
  pname = "libmesode";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "libmesode";
    rev = version;
    sha256 = "1bxnkhrypgv41qyy1n545kcggmlw1hvxnhwihijhhcf2pxd2s654";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ openssl expat libtool check ];

  dontDisableStatic = true;

  doCheck = true;

  meta = with lib; {
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
    homepage = "https://github.com/profanity-im/libmesode/";
    license = with licenses; [ gpl3Only mit];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ devhell ];
  };
}
