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
}:

buildPecl rec {
  pname = "ddtrace";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-o9g0PT/EbBlB9h2FGyYJsKoNUcJIhGR0hv3owztcvcw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-vcM+iLpJiIxMqw/Xgq4E3hbY77+H1T1UkdJpUOO6dmo=";
  };

  env.NIX_CFLAGS_COMPILE = "-O2";

  # Fix double slashes in Makefile paths to prevent impure path errors during
  # linking. The Makefile has /$(builddir)/components-rs/... but builddir is
  # already absolute (/build/source), creating //build/source/... paths.
  postConfigure = ''
    substituteInPlace Makefile --replace-fail '/$(builddir)/components-rs' '$(builddir)/components-rs'
  '';

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
