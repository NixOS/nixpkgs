{
  lib,
  buildGoModule,
  fetchzip,
  pkg-config,
  alsa-lib,
}:
buildGoModule {
  name = "termsonic";
  version = "0-unstable-2025-01-07";

  src = fetchzip {
    url = "https://git.sixfoisneuf.fr/termsonic/snapshot/termsonic-1dd63d453b109c79967726106035cda9744bbe11.zip";
    hash = "sha256-HPI4G+bGHejTwVsb8YIU6b7KnIrkqzDf8zZQAWmcfks=";
  };

  vendorHash = "sha256-+v7i69b4d11IGnraE6ROscFmqCVLHnkyI2pW+NS1v8k=";

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
