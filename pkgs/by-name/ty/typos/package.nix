{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.42.3";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "typos";
    tag = "v${version}";
    hash = "sha256-u9hjY/d4Ul+EvZIoTJzWkUl4j+Vzcvu61x2USP0hGiw=";
  };

  cargoHash = "sha256-ED/jkTlVPqM5VDDEvKPDcF0/jFYfyvszTuPSMZUNuY0=";

  passthru.updateScript = nix-update-script { };

  preCheck = ''
    export LC_ALL=C.UTF-8
  '';

  postCheck = ''
    unset LC_ALL
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      mgttlinger
      chrjabs
    ];
  };
}
