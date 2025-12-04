{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  # Remove "? null" once https://github.com/NixOS/nixpkgs/pull/444714 is merged
  tt-smi ? null,
  pstree,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tt-system-tools";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-system-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bJtDfOXwtIKQMu8B+5/UYLmwBv/KTtGEsxAUhF2w6OY=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 tt-oops/tt-oops.sh $out/bin/tt-oops
    wrapProgram "$out/bin/tt-oops" \
      --prefix PATH : ${
        lib.makeBinPath [
          tt-smi
          pstree
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "System tools for Tenstorrent cards";
    homepage = "https://github.com/tenstorrent/tt-system-tools";
    changelog = "https://github.com/tenstorrent/tt-system-tools/blob/${finalAttrs.src.tag}/debian/changelog";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
    platforms = lib.platforms.linux;
  };
})
