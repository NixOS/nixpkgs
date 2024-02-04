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
  version = "0.96.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-SXhva2acXIOuru8tTdRt5OU3Pce5eHm6SOn/y7N3ZIs=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "datadog-profiling-5.0.0" = "sha256-/Z1vGpAHpU5EO80NXnzyAHN4s3iyA1jOquBS8MH1nOo=";
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
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
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
