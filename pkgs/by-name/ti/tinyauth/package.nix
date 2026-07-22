{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs-slim,
  pnpmConfigHook,
  pnpmBuildHook,
  pnpm_11,
  fetchPnpmDeps,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinyauth";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "tinyauthapp";
    repo = "tinyauth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-leXqelsPCLixhxqJbL7aDgGIzj1KcZMnR/1UxRPa1bo=";
  };

  vendorHash = "sha256-rlMttXywppA39Vip6pIos4tY5434vvtN8dbhVn+S2Kg=";

  subPackages = [ "cmd/tinyauth" ];

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X github.com/tinyauthapp/tinyauth/internal/model.Version=v${finalAttrs.version}"
    "-X github.com/tinyauthapp/tinyauth/internal/model.CommitHash=${finalAttrs.src.rev}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend}/dist internal/assets/dist
  '';

  frontend = stdenvNoCC.mkDerivation {
    pname = "tinyauth-frontend";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      nodejs-slim
      pnpmConfigHook
      pnpmBuildHook
      pnpm_11
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-WLPJ1ZH2mEoQKFa6F5TOmTfbcgN5lXKZZHHvgI4mMq4=";
    };

    pnpmRoot = "frontend";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r frontend/dist $out

      runHook postInstall
    '';
  };

  passthru = {
    tests = {
      inherit (nixosTests) tinyauth;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "Simple authentication middleware for web apps";
    homepage = "https://tinyauth.app";
    changelog = "https://github.com/tinyauthapp/tinyauth/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "tinyauth";
    maintainers = with lib.maintainers; [
      shaunren
    ];
    platforms = lib.platforms.unix;
  };
})
