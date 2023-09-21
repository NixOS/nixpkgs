{ lib
, stdenv
, buildPecl
, cargo
, rustc
, fetchFromGitHub
, rustPlatform
, curl
, pcre2
, libiconv
, darwin
}:

buildPecl rec {
  pname = "ddtrace";
  version = "0.89.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-wTGQV80XQsBdmTQ+xaBKtFwLO3S+//9Yli9aReXDlLA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "datadog-profiling-2.2.0" = "sha256-PWzC+E2u0hM0HhU0mgZJZvFomEJdQag/3ZK1FibSLG8=";
    };
  };

  env.NIX_CFLAGS_COMPILE = "-O2";

  nativeBuildInputs = [
    cargo
    rustc
  ] ++ lib.optionals stdenv.isLinux [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.rustPlatform.bindgenHook
    darwin.apple_sdk_11_0.rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    curl
    pcre2
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.frameworks.Security
    darwin.apple_sdk_11_0.Libsystem
    libiconv
  ];

  meta = {
    changelog = "https://github.com/DataDog/dd-trace-php/blob/${src.rev}/CHANGELOG.md";
    description = "Datadog Tracing PHP Client";
    homepage = "https://github.com/DataDog/dd-trace-php";
    license = with lib.licenses; [ asl20 bsd3 ];
    maintainers = lib.teams.php.members;
  };
}
