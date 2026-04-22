{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  bun,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinyauth";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "steveiliop56";
    repo = "tinyauth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VeII5jSNUJpGZgqons1o1fp6KXxDOBhSMciSqtQfaC4=";
  };

  vendorHash = "sha256-XP+kVfcDKWAvBdrvGjiTdWh7jNe6qiDsgVjPrFFPoDU=";

  subPackages = [ "cmd/tinyauth" ];

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X github.com/steveiliop56/tinyauth/internal/config.Version=v${finalAttrs.version}"
    "-X github.com/steveiliop56/tinyauth/internal/config.CommitHash=${finalAttrs.src.rev}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend}/dist internal/assets/dist
  '';

  frontend = stdenvNoCC.mkDerivation {
    pname = "tinyauth-frontend";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/frontend";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
    ];

    configurePhase = ''
      runHook preConfigure

      bun install --no-progress --frozen-lockfile
      substituteInPlace node_modules/.bin/{tsc,vite} \
        --replace-fail "/usr/bin/env node" "${lib.getExe bun}"

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      bun run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r dist $out

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-FRACDa1akm+JnYIRwNXRcomzDIMCIAlJDbjMyS77sNA=";
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
    changelog = "https://github.com/steveiliop56/tinyauth/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "tinyauth";
    maintainers = with lib.maintainers; [
      shaunren
    ];
    platforms = lib.platforms.unix;
  };
})
