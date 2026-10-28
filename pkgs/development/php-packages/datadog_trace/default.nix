{
  lib,
  php,
  stdenv,
  buildPecl,
  cargo,
  cmake,
  rustc,
  fetchFromGitHub,
  rustPlatform,
  curl,
  pcre2,
  valgrind,
  libiconv,
}:

buildPecl rec {
  pname = "ddtrace";
  version = "1.26.2";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-35Pb68wFg/HwuN3qrxRFo/rN9rOdnx30vUScWPQGQ5s=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-IcyygiMLiaKkb+4W+YtTQuRrunego6KtbISw5u1egoI=";
  };

  env.NIX_CFLAGS_COMPILE = "-O2";

  configureFlags = [ "--enable-ddtrace-libddwaf-source" ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cargo
    cmake
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    curl
    pcre2
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    valgrind
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://github.com/DataDog/dd-trace-php/blob/${src.tag}/CHANGELOG.md";
    description = "Datadog Tracing PHP Client";
    homepage = "https://github.com/DataDog/dd-trace-php";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    teams = [ lib.teams.php ];
  };
}
