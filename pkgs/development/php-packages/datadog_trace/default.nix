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
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-sjr/kL4mlmASE+L3vcEyOdrgUBi13S5+/oq+3EwZQFA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-P/WOTKfyeG20/1a+Uf5a5C/gBnqiquIJSvmq3xLkzCE=";
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
  };
}
