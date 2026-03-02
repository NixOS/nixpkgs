{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  dbus,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "veryl";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "veryl-lang";
    repo = "veryl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dqVEl/sClzhLiX5ung4au6dXUkeMbKPdoSDRV0evT3w=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-0RFzZwaF8hVVBBBC7l9Ql9mN99cxI2tiWlo7eNX/Tho=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    dbus
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd veryl \
      --bash <($out/bin/veryl metadata --completion bash) \
      --fish <($out/bin/veryl metadata --completion fish) \
      --zsh <($out/bin/veryl metadata --completion zsh)
  '';

  checkFlags = [
    # takes over an hour
    "--skip=tests::progress"
    # tempfile::tempdir().unwrap() -> "No such file or directory"
    "--skip=tests::bump_version"
    "--skip=tests::bump_version_with_commit"
    "--skip=tests::check"
    "--skip=tests::load"
    "--skip=tests::lockfile"
    "--skip=tests::publish"
    "--skip=tests::publish_with_commit"
    # "Permission Denied", while making its cache dir?
    "--skip=analyzer::test_25_dependency"
    "--skip=analyzer::test_68_std"
    "--skip=emitter::test_25_dependency"
    "--skip=emitter::test_68_std"
    "--skip=filelist::test"
    "--skip=path::directory_directory"
    "--skip=path::directory_target"
    "--skip=path::source_directory"
    "--skip=path::source_target"
    "--skip=path::rootdir_directory_directory"
    "--skip=path::rootdir_directory_target"
    "--skip=path::rootdir_source_directory"
    "--skip=path::rootdir_source_target"
    "--skip=path::subdir_directory_directory"
    "--skip=path::subdir_directory_target"
    "--skip=path::subdir_source_directory"
    "--skip=path::subdir_source_target"
  ];

  meta = {
    description = "Modern Hardware Description Language";
    homepage = "https://veryl-lang.org/";
    changelog = "https://github.com/veryl-lang/veryl/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "veryl";
  };
})
