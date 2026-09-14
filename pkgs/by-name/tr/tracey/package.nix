{
  fetchFromGitHub,
  fetchPnpmDeps,
  gitUpdater,
  git,
  lib,
  nodejs,
  pnpmConfigHook,
  pnpm,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "tracey";
  version = "1.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bearcove";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-S0uAAZpJrYp24ROMjGn3gcMjzzsBjOeICRO0qXXnmxg=";
  };
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  cargoHash = "sha256-AUDBWCWXBdCUK3535RlFWsbUVH0Uws6DxqWzcfyZrJI=";

  pnpmDeps = fetchPnpmDeps {
    inherit pname src;
    sourceRoot = "${src.name}/crates/tracey/src/bridge/http/dashboard";
    fetcherVersion = 3;
    hash = "sha256-VppxlvJGqM+bJHAg/YwDq7/ZrfJt9fp1F9SZPEul0Vg=";
  };
  pnpmRoot = "crates/tracey/src/bridge/http/dashboard";

  prePnpmInstall = ''
    # Approve build scripts of dependencies that require it
    pnpm config set --location=project --json allowBuilds '{ "esbuild": true, "@parcel/watcher": true }'
  '';

  #preBuild = ''
  #  set -e
  #  pushd crates/tracey/src/bridge/http/dashboard
  #  ls -la
  #  pnpm approve-builds --all
  #  popd
  #'';

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  nativeCheckInputs = [
    git
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "CLI, Web, LSP, and MCP toolkit to measure spec coverage in Rust codebases";
    homepage = "https://tracey.bearcove.eu/";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "tracey";
    maintainers = with lib.maintainers; [
      olestrohm
    ];
  };
}
