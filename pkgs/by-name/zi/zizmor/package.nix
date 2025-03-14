{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "zizmor";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    tag = "v${version}";
    hash = "sha256-G0cayE8UDahLYZl2HG8315YYUOhH5u6L/VRWHqqavPk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-CRjr4X525t7xaFsnX3gOy4+HJis5T8nw6zrhkW60Bpw=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for finding security issues in GitHub Actions setups";
    homepage = "https://woodruffw.github.io/zizmor/";
    changelog = "https://github.com/woodruffw/zizmor/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "zizmor";
  };
}
