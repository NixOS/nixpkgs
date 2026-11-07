{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  tt-smi,
  pstree,
  pciutils,
  gawk,
  coreutils,
  nixosTests,
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

  # make the override file selectable, and don't divide by zero when the
  # override is set but no card is present
  postPatch = ''
    substituteInPlace hugepages-setup/hugepages-setup.sh \
      --replace-fail 'file_path="/opt/tenstorrent/bin/hugepages-override.txt"' \
        'file_path="''${TT_HUGEPAGES_OVERRIDE_FILE:-/opt/tenstorrent/bin/hugepages-override.txt}"' \
      --replace-fail 'HP_COUNT=$((HP_OVERRIDE / TT_COUNT))' \
        'HP_COUNT=$((TT_COUNT ? HP_OVERRIDE / TT_COUNT : 0))'
  '';

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

    install -Dm755 hugepages-setup/hugepages-setup.sh $out/libexec/tt-system-tools/hugepages-setup
    wrapProgram "$out/libexec/tt-system-tools/hugepages-setup" \
      --prefix PATH : ${
        lib.makeBinPath [
          pciutils
          gawk
          coreutils
        ]
      }

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) tenstorrent;
  };

  meta = {
    description = "System tools for Tenstorrent cards";
    homepage = "https://github.com/tenstorrent/tt-system-tools";
    changelog = "https://github.com/tenstorrent/tt-system-tools/blob/${finalAttrs.src.tag}/debian/changelog";
    teams = [ lib.teams.tenstorrent ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
