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
  version = "0.3.5.1";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "upbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-noH1Ck62VW0URaQbNjo4wLA4bAYpuZCOF0jHJ0f8l9w=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-PT86WEJbj2WxYZdxB5SyZRwO/MyWFV3wB+C/LYxK7ZU=";

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

  # Needed for TestRunServePersistListenBindFailureDoesNotWriteWebConfig
  __dariwnAllowLocalNetworking = true;

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
        hash = "sha256-8AnituGTEld/x3R+WtLSMeERPZgo5JtiQdB6CBaYlpY=";
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
    changelog = "https://github.com/autobrr/upbrr/releases/tag/v${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [
      pta2002
    ];
    mainProgram = "upbrr";
    platforms = lib.platforms.unix;
  };
})
