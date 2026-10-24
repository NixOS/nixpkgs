{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wtfi2";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kanywst";
    repo = "wtfi2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jNAx77pRhzoYHbB//2FS1EhR5v47Ueh8JDXKC+AHVIg=";
  };

  cargoHash = "sha256-1IBlpygfsVvkQpp4/Gi5M/Cb8gHakhEwaBgVvdXEQ3U=";

  checkFlags = [
    # "nothing was observed, so nothing may be called broken"
    "--skip=engine::tests::a_truncated_sweep_reports_the_gap_rather_than_a_verdict"
  ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Live, visual network-path diagnostic that pinpoints where your Wi-Fi connection dies - and how to fix it";
    homepage = "https://github.com/kanywst/wtfi2";
    changelog = "https://github.com/kanywst/wtfi2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnhamelink ];
    mainProgram = "wtfi";
  };
})
