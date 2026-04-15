{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  stdenvNoCC,
  bun,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinyauth";
  version = "5.0.6";

  src = fetchFromGitHub {
    owner = "steveiliop56";
    repo = "tinyauth";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-V75kjO34b1DBBI5aJMfn9finHSbVbWqQ34CH68gzrig=";
  };

  vendorHash = "sha256-iyduJgKt9OAkOY6J8J1GztCkYEssr/TcB43L6/Qdzmc=";

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

  postPatch = ''
    ${lib.getExe git} apply --directory paerser/ patches/nested_maps.diff
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
    outputHash = "sha256-pd5v5lD8Lyhf21OQvzjDTh63EcAe7E1OAoQuFGhAOX8=";
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
