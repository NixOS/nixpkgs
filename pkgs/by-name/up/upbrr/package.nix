{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
  stdenvNoCC,
  nix-update-script,
  nodejs-slim_24,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  ffmpeg-headless,
  makeBinaryWrapper,
}:
let
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_24; };
in
buildGo127Module (finalAttrs: {
  pname = "upbrr";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "upbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H7+5s5OwpbGuUOTSKOStTigBsqCvn5FNaFWKNwcNOaQ=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-p12mIRlZiDPheJLcMJIo0D6x0SWF1ctogfo8D+2cQp4=";

  subPackages = [ "cmd/upbrr" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postConfigure = ''
    cp -R ${finalAttrs.passthru.upbrr-webui}/. "internal/webserver/assets"
  '';

  postInstall = ''
    wrapProgram $out/bin/upbrr \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.src.tag}"
  ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru = {
    upbrr-webui = stdenvNoCC.mkDerivation (finalAttrs': {
      pname = "${finalAttrs.pname}-webui";
      inherit (finalAttrs) src version;

      __structuredAttrs = true;

      nativeBuildInputs = [
        nodejs-slim_24
        pnpmConfigHook
        pnpmBuildHook
        pnpm
      ];

      sourceRoot = "${finalAttrs.src.name}/webui";

      pnpmDeps = fetchPnpmDeps {
        inherit pnpm;
        inherit (finalAttrs')
          pname
          src
          sourceRoot
          ;
        fetcherVersion = 4;
        hash = "sha256-3uIqj2XeLdI96hXnEZIhtlLCeQVigfXE13iC0mfe4f4=";
      };

      pnpmBuildScript = "build:bundle";

      installPhase = ''
        runHook preInstall
        cp -r dist $out
        runHook postInstall
      '';
    });

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage=upbrr-webui"
      ];
    };
  };

  meta = {
    description = "Guided upload preparation tool for private torrent trackers";
    license = lib.licenses.gpl2Plus;
    homepage = "https://upbrr.com";
    changelog = "https://github.com/autobrr/upbrr/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [
      pta2002
    ];
    mainProgram = "upbrr";
  };
})
