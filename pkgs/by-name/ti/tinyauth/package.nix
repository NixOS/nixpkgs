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
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "steveiliop56";
    repo = "tinyauth";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ypM56yrUWF1OzCj5RBGyEhZzjyDcko7SPQ+eVhHEzmA=";
  };

  vendorHash = "sha256-qELLarAR78WkDoJKtqaqzIZaTBCuHP41JCyjLZ4aMtM=";

  subPackages = [ "cmd/tinyauth" ];

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
    outputHash = "sha256-pB94TUwjm5GmEmgjqkr7QH9BoRhKCSbxQVOc+2fCz2c=";
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
