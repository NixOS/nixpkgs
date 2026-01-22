{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
    hash = "sha256-LVzpf5JDhL0zzKp+/loj3Et5R7fZh4h28eEO51VtKqc=";
  };

  cargoHash = "sha256-gXwpdWE7Te0ngGUu6meaIpY6lUX1yh8pu5G9KVSNNME=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = {
    description = "Provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ereslibre
    ];
    platforms = lib.platforms.unix;
  };
}
