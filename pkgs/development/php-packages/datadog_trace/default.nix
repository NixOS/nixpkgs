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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-9MTIbbV/JnSTSerHpJIReeTZtW1lxIIeXCGR9RaCZG4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-97PlYf9KY0C+J1HYkJM/oqAjxwz+c8cYtF53L4EvE5I=";
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
