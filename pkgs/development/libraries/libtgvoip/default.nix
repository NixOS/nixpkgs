{ stdenv, lib, fetchFromGitHub, fetchpatch
, pkg-config, autoreconfHook
, openssl, libopus, alsa-lib, libpulseaudio
}:

with lib;

stdenv.mkDerivation rec {
  pname = "libtgvoip";
  version = "unstable-2021-01-01";

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "libtgvoip";
    rev = "13a5fcb16b04472d808ce122abd695dbf5d206cd";
    sha256 = "12p6s7vxkf1gh1spdckkdxrx7bjzw881ds9bky7l5fw751cwb3xd";
  };

  # To fix the build without external webrtc:
  patches = [
    (fetchpatch {
      # Use methods from updated webrtc.
      url = "https://github.com/telegramdesktop/libtgvoip/commit/13a5fcb16b04472d808ce122abd695dbf5d206cd.patch";
      sha256 = "0wapqvml3yyv5dlp2q8iih5rfvfnkngll69krhnw5xsdjy22sp7r";
      revert = true;
    })
    (fetchpatch {
      # Allow working with external webrtc.
      url = "https://github.com/telegramdesktop/libtgvoip/commit/6e82b6e45664c1f80b9039256c99bebc76d34672.patch";
      sha256 = "0m87ixja70vnm80a9z4gxk0yl7n64y59smczxb88lxnj6kdgih7x";
      revert = true;
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl libopus alsa-lib libpulseaudio ];
  enableParallelBuilding = true;

  meta = {
    description = "VoIP library for Telegram clients";
    license = licenses.unlicense;
    platforms = platforms.linux;
    homepage = "https://github.com/telegramdesktop/libtgvoip";
    maintainers = with maintainers; [ ilya-fedin ];
  };
}
