{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  git,
  nixosTests,
  python3,
  vaultwarden,
}:

let
  version = "2025.1.1";

  suffix = lib.head (lib.match "[0-9.]*([a-z]*)" version);

  bw_web_builds = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "bw_web_builds";
    rev = "v${version}";
    hash = "sha256-wQGpl7N0D83FrrV4T+LFe9h3n5Q/MqLbGGO2F5R9k2g=";
  };

in
buildNpmPackage rec {
  pname = "vaultwarden-webvault";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "web-v${lib.removeSuffix suffix version}";
    hash = "sha256-Bq133V8CsDMnLeaKrW5JmLTGRaZVLRbp+tTgG725tqE=";
  };

  npmDepsHash = "sha256-bWcp3VJI2bObLH/XBx3cdxXQY9Cw+IFpeNA2TXVTtFg=";

  postPatch = ''
    ln -s ${bw_web_builds}/{patches,resources} ..
    PATH="${git}/bin:$PATH" VAULT_VERSION="${lib.removePrefix "web-" src.rev}" \
      bash ${bw_web_builds}/scripts/apply_patches.sh
  '';

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
    inherit bw_web_builds;
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
