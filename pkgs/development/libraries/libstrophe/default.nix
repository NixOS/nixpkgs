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
  pname = "libstrophe";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "strophe";
    repo = pname;
    rev = version;
    sha256 = "sha256-jT4VIqqUldCj3Rsb5MC74WXYQyTqOZxzFADf47TBV8c=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ openssl expat libtool check ];

  dontDisableStatic = true;

  doCheck = true;

  meta = with lib; {
    description = "A simple, lightweight C library for writing XMPP clients";
    longDescription = ''
      libstrophe is a lightweight XMPP client library written in C. It has
      minimal dependencies and is configurable for various environments. It
      runs well on both Linux, Unix, and Windows based platforms.
    '';
    homepage = "https://strophe.im/libstrophe/";
    license = with licenses; [ gpl3Only mit ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ devhell flosse ];
  };
}

