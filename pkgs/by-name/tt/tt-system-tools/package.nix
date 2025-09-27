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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-system-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZtEs1XRho/EJShAV6+8Db2wxCK2QQBuNp+TRqb+ZiM4=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 tt-oops/tt-oops.sh $out/bin/tt-oops
    wrapProgram "$out/bin/tt-oops" \
      --prefix PATH : ${
        lib.makeBinPath [
          tt-smi
          pstree
        ]
      }
  '';

  meta = {
    description = "System tools for Tenstorrent cards";
    homepage = "https://github.com/tenstorrent/tt-system-tools";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
})
