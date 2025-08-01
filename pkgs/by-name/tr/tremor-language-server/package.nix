{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tremor-language-server";
  version = "0.13.0-rc.11";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-language-server";
    rev = "v${version}";
    sha256 = "sha256-gooHNSBEcqyTMOSBG7T01kSdCWKK98dbE8+nuwvQkS0=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-tMs5DRuWuMXIpj5YU4bR4mAlzv7nWycmzDOqMuihj7M=";

  meta = with lib; {
    description = "Tremor Language Server (Trill)";
    homepage = "https://www.tremor.rs/docs/next/getting-started/tooling";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
