{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  python3,
  vaultwarden,
}:

buildNpmPackage rec {
  pname = "vaultwarden-webvault";
  version = "2025.5.0.0";

  src = fetchFromGitHub {
    owner = "vaultwarden";
    repo = "vw_web_builds";
    tag = "v${version}";
    hash = "sha256-Z3QPKeo7+QV3XnECvLXz2Upv41h579WoVH0Vev0fixk=";
  };

  npmDepsHash = "sha256-FC3x7H0MQDVGajtaMA2PUK5+soG6kD9AaDbq/s1pOnY=";

  nativeBuildInputs = [
    python3
  ];

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

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

  meta = with lib; {
    description = "Integrates the web vault into vaultwarden";
    homepage = "https://github.com/dani-garcia/bw_web_builds";
    changelog = "https://github.com/dani-garcia/bw_web_builds/releases/tag/v${version}";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    inherit (vaultwarden.meta) maintainers;
  };
}
