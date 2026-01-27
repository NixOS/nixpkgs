{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  bun,
  nodejs-slim_latest,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinyauth";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "steveiliop56";
    repo = "tinyauth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v/Wf3bLoDHcGmlmL9hLbtt/tBuTRAN0SDFmON82Nn0I=";
  };

  vendorHash = "sha256-2sHZZ0negYHBIVzFqtRS/AUe67rrS0jcLb1iWEecMl4=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X tinyauth/internal/config.Version=v${finalAttrs.version}"
    "-X tinyauth/internal/config.CommitHash=${finalAttrs.src.rev}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend}/dist internal/assets/dist
  '';

  postPatch = ''
    substituteInPlace cmd/root.go \
      --replace-fail "/data/resources" "/var/lib/tinyauth/resources" \
      --replace-fail "/data/tinyauth.db" "/var/lib/tinyauth/tinyauth.db"
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
      nodejs-slim_latest
    ];

    configurePhase = ''
      runHook preConfigure

      bun install --no-progress --frozen-lockfile
      substituteInPlace node_modules/.bin/{tsc,vite} \
        --replace-fail "/usr/bin/env node" "${lib.getExe nodejs-slim_latest}"

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

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-0UUIcMImGzt6n2SF1nKX4FnZBn3bzjqlOsCPlJjcIY0=";
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
