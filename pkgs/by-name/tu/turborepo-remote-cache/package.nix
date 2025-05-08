{
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  pnpm_10,
  stdenv,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "turborepo-remote-cache";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "ducktors";
    repo = "turborepo-remote-cache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BzTOpkUo3ZlY1M57u19t8XncCeFFT1qCO2Ll7o/QaVo=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-stkm+wKDi6/czUrpj/i5aLmQlx3cw1BPOHEuzKlwjGE=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm_10.configHook
  ];
  # pnpm runs the linter and rimraf which for a reason I don't understand fails on linux platforms.
  # pnpm:docker only runs the build command.
  buildPhase = ''
    runHook preBuild

    pnpm build:docker

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/turborepo-remote-cache
    cp -r {dist,node_modules} $out/lib/node_modules/turborepo-remote-cache

    makeWrapper "${lib.getExe nodejs}" "$out/bin/turborepo-remote-cache" \
      --add-flags "--enable-source-maps" \
      --add-flags "$out/lib/node_modules/turborepo-remote-cache/dist/index.js"

    runHook postInstall
  '';

  meta = {
    description = "Open source implementation of the Turborepo custom remote cache server.";
    changelog = "https://github.com/ducktors/turborepo-remote-cache/releases/tag/v${finalAttrs.version}";
    mainProgram = "turborepo-remote-cache";
    homepage = "https://github.com/ducktors/turborepo-remote-cache";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ibizaman ];
    platforms = lib.platforms.all;
  };
})
