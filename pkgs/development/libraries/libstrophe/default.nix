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
<<<<<<< HEAD
  version = "0.12.3";
=======
  version = "0.12.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "strophe";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "EDgdKJ7wqUoThy0t1r39p2lbn64uvTDoIqNCzhpWnZ8=";
=======
    sha256 = "sha256-jT4VIqqUldCj3Rsb5MC74WXYQyTqOZxzFADf47TBV8c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

