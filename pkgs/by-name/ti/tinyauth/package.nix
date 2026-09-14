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
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "tinyauthapp";
    repo = "tinyauth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JSD8MLWKLafdOCKBCCmlNq3sA4gsoN7QDhIw0sgqmyY=";
  };

  vendorHash = "sha256-gkFKt/IoN29lw9laqxHmDK77E9hCkdEv7oIEg83sfgY=";

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
      hash = "sha256-gRn1hLzNcC7lcWOj6IllBNzhkUS7IzOPzGFc568cb8w=";
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
