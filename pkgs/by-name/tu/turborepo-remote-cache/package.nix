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
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "ducktors";
    repo = "turborepo-remote-cache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-86uEO/2aWWiIRIdpESFQGpq6nHtGLqp4ZlNeeGFUGCY=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    fetcherVersion = 2;
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-40h2b/S8ttRr8YK20JuxdLvMwPoZEhp/dEd2EY3iaA4=";
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
