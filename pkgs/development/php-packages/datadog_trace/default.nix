{
  lib,
  stdenv,
  buildPecl,
  cargo,
  rustc,
  fetchFromGitHub,
  rustPlatform,
  curl,
  pcre2,
  libiconv,
  php,
}:

buildPecl rec {
  pname = "ddtrace";
  version = "0.97.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-Kx2HaWvRT+mFIs0LAAptx6nm9DQ83QEuyHNcEPEr7A4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-cwhE6M8r8QnrIiNgEekI25GcKTByySrZsigPd9/Fq7o=";
  };

  env.NIX_CFLAGS_COMPILE = "-O2";

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    curl
    pcre2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    changelog = "https://github.com/DataDog/dd-trace-php/blob/${src.rev}/CHANGELOG.md";
    description = "Datadog Tracing PHP Client";
    homepage = "https://github.com/DataDog/dd-trace-php";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    teams = [ lib.teams.php ];
    broken = lib.versionAtLeast php.version "8.4";
  };
}
