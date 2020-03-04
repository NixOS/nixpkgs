{ stdenv, lib, fetchFromGitHub, pkg-config, autoreconfHook
, openssl, libopus, alsaLib, libpulseaudio
}:

with lib;

stdenv.mkDerivation rec {
  pname = "libtgvoip";
  version = "unstable-2020-01-21";

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "libtgvoip";
    rev = "ade4434f1c6efabecc3b548ca1f692f8d103d22a";
    sha256 = "1bhnx3sknadx7a4qk9flh356kffb02xx32grj7cj7ik4rarccgp0";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl libopus alsaLib libpulseaudio ];
  enableParallelBuilding = true;

  meta = {
    description = "VoIP library for Telegram clients";
    license = licenses.unlicense;
    platforms = platforms.linux;
    homepage = https://github.com/telegramdesktop/libtgvoip;
    maintainers = with maintainers; [ ilya-fedin ];
  };
}
