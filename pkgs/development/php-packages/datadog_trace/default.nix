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
  valgrind,
  libiconv,
}:

buildPecl rec {
  pname = "ddtrace";
  version = "1.19.2";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-pfhoj5a+kUVOuMnAHgL2s05Pcc6uhlTcp2t5aj1eJ0E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-Onkkea1xntfSKVr2aoCy1Z9wGIdv/L7HRh7LGxv738M=";
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
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    valgrind
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
