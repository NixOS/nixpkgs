{
  lib,
  php,
  stdenv,
  buildPecl,
  cargo,
  rustc,
  fetchFromGitHub,
  rustPlatform,
  curl,
  pcre2,
  valgrind,
  libiconv,
  libddwaf,
  llvmPackages,
  pkg-config,
  zstd,
}:

buildPecl (finalAttrs: {
  pname = "ddtrace";
  version = "1.27.2";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-g3aqntLmvO6H1UH81zKsFV+a8TT0rcXZjRCm5aAQ4WM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-hOICGQJshjW90c9Vv5kVDocD7Itlqk4dQcJGTCGOuW0=";
  };

  env = {
    NIX_CFLAGS_COMPILE = "-O2";
    LIBDDWAF_PREFIX = libddwaf;
    DDTRACE_SHARED_LIBADD = "-lddwaf";
  };

  # Use the packaged shared library instead of building or downloading libddwaf.
  postPatch = ''
    substituteInPlace appsec/helper-rust/Cargo.toml \
      --replace-fail 'features = ["ring"]' 'features = ["ring", "dynamic-link"]'
  '';

  nativeBuildInputs = [
    cargo
    llvmPackages.llvm
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    curl
    libddwaf
    pcre2
    zstd
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    valgrind
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://github.com/DataDog/dd-trace-php/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Datadog Tracing PHP Client";
    homepage = "https://github.com/DataDog/dd-trace-php";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    teams = [ lib.teams.php ];
  };
})
