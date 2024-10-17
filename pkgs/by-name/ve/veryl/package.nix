{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "veryl";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "veryl-lang";
    repo = "veryl";
    rev = "v${version}";
    hash = "sha256-U4ikR2jRmHUwRycAL/t2XJtvHQniKu6skRKWn8XDIgM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-t2q3rbY84+0ayxt7a/TCD0exCm7KEs+8UbQjCtqZPoE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      dbus
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

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

  ];

  meta = {
    description = "Modern Hardware Description Language";
    homepage = "https://veryl-lang.org/";
    changelog = "https://github.com/veryl-lang/veryl/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "veryl";
  };
}
