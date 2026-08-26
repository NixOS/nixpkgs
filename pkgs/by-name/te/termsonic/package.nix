{
  lib,
  buildGoModule,
  fetchzip,
  pkg-config,
  alsa-lib,
}:
buildGoModule {
  pname = "termsonic";
  version = "0-unstable-2026-08-07";

  src = fetchzip {
    url = "https://git.sixfoisneuf.fr/termsonic/snapshot/termsonic-dd778fcc6bee41cd7ae9f6e173e7dd6f16e1f53d.zip";
    hash = "sha256-m48lJvJ83NoFuN05UH5BFTNoSftKa4giGJr3CWdaqnA=";
  };

  vendorHash = "sha256-Dptiuu1KPZrmIYwQG1gIVb9jaJXlQ+Nv6e33wZbgiqA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  strictDeps = true;

  meta = {
    homepage = "https://git.sixfoisneuf.fr/termsonic";
    description = "Subsonic client running in your terminal";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "termsonic";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
