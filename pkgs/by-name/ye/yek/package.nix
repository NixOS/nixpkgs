{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "0.16.0";
in
rustPlatform.buildRustPackage {
  pname = "yek";
  version = version;

  src = fetchFromGitHub {
    owner = "bodo-run";
    repo = "yek";
    tag = "v${version}";
    hash = "sha256-dboKZuY6mlFZu/xCoLXFJ4ARXyYs5/yOYeGkAnUKRX4=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-/J+11PRCWn0rzq3nILJYd3V8cxmwDegArUDp8i5rsTY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = 1;

  checkFlags = [
    # Tests with git fail
    "--skip=e2e_tests::test_git_boost_config"
    "--skip=e2e_tests::test_git_integration"
    "--skip=lib_tests::test_serialize_repo_with_git"
    "--skip=priority_tests::test_get_recent_commit_times_empty_repo"
    "--skip=priority_tests::test_get_recent_commit_times_with_git"
    "--skip=priority_tests::test_get_recent_commit_times_git_failure"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Serialize text files for LLM consumption";
    longDescription = ''
      Tool to read text-based files, chunk them, and serialize them for LLM consumption.
    '';
    homepage = "https://github.com/bodo-run/yek";
    changelog = "https://github.com/bodo-run/yek/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "yek";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
