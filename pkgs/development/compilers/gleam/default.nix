{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  openssl,
  erlang,
  Security,
  nix-update-script,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-gBVr4kAec8hrDBiRXa/sQUNYvgSX3nTVMwFGYRFCbSA=";
  };

  nativeBuildInputs = [
    git
    pkg-config
  ];

  buildInputs =
    [
      openssl
      erlang
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-tYSqE+bn0GUQe/xVBZTh37XsMyzFnmxgVCL0II2/3jQ=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    changelog = "https://github.com/gleam-lang/gleam/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.beam.members ++ [ lib.maintainers.philtaken ];
  };
}
