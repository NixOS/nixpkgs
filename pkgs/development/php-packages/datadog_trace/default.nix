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
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-ZwBN2lXX640SKrPgVibnAUtrBZbG9uIV9mZSAEDcHwA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-T5MHDc5aOK4l3HfhGqK7JW69IiPVIe86LYBC1Gu35OA=";
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
