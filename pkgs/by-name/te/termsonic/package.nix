{
  lib,
  buildGoModule,
  fetchzip,
  pkg-config,
  alsa-lib,
}:
buildGoModule rec {
  name = "termsonic";
  version = "0-unstable-2024-09-15";

  src = fetchzip {
    url = "https://git.sixfoisneuf.fr/termsonic/snapshot/termsonic-93328e0ca6c0ed2424550c7a164b4b1212a554b6.zip";
    hash = "sha256-qn0EB1lCU8nvgwcIuZ0Xt9yGTBz5bSnJelPF8mG6D1k=";
  };

  vendorHash = "sha256-hBYgRKL9ZFzYy/wLCWacw8I6aqtD5O7lLsB9U5RmLjw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://git.sixfoisneuf.fr/termsonic";
    description = "Subsonic client running in your terminal";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "termsonic";
    maintainers = with maintainers; [ mksafavi ];
  };
}
