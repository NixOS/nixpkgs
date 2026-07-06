{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  python3,
  dart-sass,
  vaultwarden,
}:

buildNpmPackage rec {
  pname = "vaultwarden-webvault";
  version = "2026.4.1+0";

  src = fetchFromGitHub {
    owner = "vaultwarden";
    repo = "vw_web_builds";
    tag = "v${version}";
    hash = "sha256-CIKhdCQwx1zS8rkOtZoG9WDxtweSmrCNL6HfZXi+mM8=";
  };

  # Upstream lockfile is out of sync for @napi-rs/cli (spec 3.5.1, resolved
  # 3.2.0), which makes offline `npm ci` hit the registry. The desktop
  # workspace is unused here. https://github.com/bitwarden/clients/pull/20480
  postPatch = ''
    substituteInPlace package-lock.json \
      --replace-fail '"@napi-rs/cli": "3.5.1"' '"@napi-rs/cli": "3.2.0"'
  '';

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-NBhII5HySIkv0bCeWjH6MknX5NMp11Gwno7RnfCKgjc=";

  nativeBuildInputs = [
    python3
    dart-sass
  ];

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

  preBuild = ''
    echo "export const compilerCommand = ['dart-sass'];" > node_modules/sass-embedded/dist/lib/src/compiler-path.js
  '';

  npmRebuildFlags = [
    # FIXME one of the esbuild versions fails to download @esbuild/linux-x64
    "--ignore-scripts"
  ];

  npmBuildScript = "dist:oss:selfhost";

  npmBuildFlags = [
    "--workspace"
    "apps/web"
  ];

  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/vaultwarden
    mv apps/web/build $out/share/vaultwarden/vault
    runHook postInstall
  '';

  passthru = {
    tests = nixosTests.vaultwarden;
  };

  meta = {
    description = "Integrates the web vault into vaultwarden";
    homepage = "https://github.com/vaultwarden/vw_web_builds";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    inherit (vaultwarden.meta) maintainers;
  };
}
