{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zizmor";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-llxIuWgaRNJsl/piQ1BMqvE2MKnSnR5qxjLFqZ5z13I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OVGaHLA/VzF8wGrWrHaKpYDcp4ZeR9mf2s5I+u5ddcs=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9.]+\.[0-9.]+\.[0-9.])+$" ];
  };

  meta = {
    description = "Tool for finding security issues in GitHub Actions setups";
    homepage = "https://docs.zizmor.sh/";
    changelog = "https://github.com/zizmorcore/zizmor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "zizmor";
  };
})
