{
  lib,
  buildGoModule,
  fetchzip,
  pkg-config,
  alsa-lib
}:
buildGoModule rec {
  name = "termsonic";
  version = "0-unstable-2024-02-02";

  src = fetchzip {
    url = "https://git.sixfoisneuf.fr/termsonic/snapshot/termsonic-7a3aabee59e1a427aff755fc69759265ad9d0adc.zip";
    hash = "sha256-C5/4679qw4CAdUt9lXpPIR3yejrPdddvmjgbpLF3SvA=";
  };

  vendorHash = "sha256-wCtQD9f1mbN/0qUZnamPoVn9p4Ra5dQ34vlT+XjPF3k=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://git.sixfoisneuf.fr/termsonic";
    description = "A Subsonic client running in your terminal";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "termsonic";
    maintainers = with maintainers; [ mksafavi ];
  };
}
