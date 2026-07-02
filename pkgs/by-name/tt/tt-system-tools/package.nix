{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  tt-smi,
  pstree,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tt-system-tools";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-system-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fqmMO6Zo61gO0HtKasSKTt7kC8YGr5crymwbqVNQLck=";
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
