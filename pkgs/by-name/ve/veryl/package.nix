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
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "veryl-lang";
    repo = "veryl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-X3DF1d2rYrdOc/M4Wwp0FnMK5GC33SlmHpjJ3hyeLso=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-0t2809LWMDU+IKWdxjd4kc+qyI8f/rIbWQ1C3f5BBwY=";

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
    "--skip=native_test::test"
    "--skip=native_test::test_ignored_attribute"
    "--skip=native_test::test_wave_dump"
    "--skip=analyzer::test_25_dependency"
    "--skip=analyzer::test_84_package_self_ref_2"
    "--skip=analyzer::test_68_std"
    "--skip=emitter::test_84_package_self_ref_2"
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
