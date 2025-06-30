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
  version = "2025.6.0.0";

  src = fetchFromGitHub {
    owner = "vaultwarden";
    repo = "vw_web_builds";
    tag = "v${version}";
    hash = "sha256-hbuofQJOYpiaeK1tgJZeYVbuYbkhIHLEPYSUxvpkiRE=";
  };

  npmDepsHash = "sha256-Gx0Y1BXaQZtccdlpQhcY7LKm1cXup8sgZu/NZU3F/DM=";

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

  meta = {
    description = "Integrates the web vault into vaultwarden";
    homepage = "https://github.com/dani-garcia/bw_web_builds";
    changelog = "https://github.com/dani-garcia/bw_web_builds/releases/tag/v${lib.concatStringsSep "." (lib.take 3 (lib.versions.splitVersion version))}";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    inherit (vaultwarden.meta) maintainers;
  };
}
