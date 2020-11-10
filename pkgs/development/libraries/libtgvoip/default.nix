{ stdenv, lib, fetchFromGitHub, pkg-config, autoreconfHook
, openssl, libopus, alsaLib, libpulseaudio
}:

with lib;

stdenv.mkDerivation rec {
  pname = "libtgvoip";
  version = "unstable-2020-03-02";

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "libtgvoip";
    rev = "e422d2a80546a32ab7166a9b1058bacfc5daeefc";
    sha256 = "0n6f7215k74039j0zmicjzhj6f45mq6fvkrwzyzibcrv87ib17fc";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl libopus alsaLib libpulseaudio ];
  enableParallelBuilding = true;

  meta = {
    description = "VoIP library for Telegram clients";
    license = licenses.unlicense;
    platforms = platforms.linux;
    homepage = "https://github.com/telegramdesktop/libtgvoip";
    maintainers = with maintainers; [ ilya-fedin ];
  };
}
