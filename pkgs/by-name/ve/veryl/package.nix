{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  dbus,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "veryl";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "veryl-lang";
    repo = "veryl";
    rev = "v${version}";
    hash = "sha256-J1FYgVrpiczTTaMvE7IBdd4aqNI4XXXqvgR7SWaVen0=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2AWVmdVQAA0+h9xegcWSAjnpa68A+2zazHwKzNKqaTo=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      dbus
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
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
  ];

  meta = {
    description = "Modern Hardware Description Language";
    homepage = "https://veryl-lang.org/";
    changelog = "https://github.com/veryl-lang/veryl/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "veryl";
  };
}
