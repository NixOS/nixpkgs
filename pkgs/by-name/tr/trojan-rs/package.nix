{
  fetchFromGitHub,
  rustPlatform,
  lib,
  ipset,
}:

rustPlatform.buildRustPackage {
  pname = "trojan-rs";
  version = "0.16.0-unstable-2024-11-21";

  src = fetchFromGitHub {
    owner = "lazytiger";
    repo = "trojan-rs";
    rev = "a996b83e3d57b571fa59f01034fcdd32a09ee8bc";
    hash = "sha256-rtYvsFxxhkUuR/tLrRFvRBLG8C84Qs0kYmXkNP/Ai3c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1HrIjkv/CyHCiC3RzQ2M8kHl74eMsWNfypr8PsL6kA0=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  buildInputs = [ ipset ];

  env.RUSTC_BOOTSTRAP = true;
  env.RUSTFLAGS = "--cfg tokio_unstable";

  meta = {
    homepage = "https://github.com/lazytiger/trojan-rs";
    description = "Trojan server and proxy programs written in Rust";
    license = lib.licenses.mit;
    mainProgram = "trojan";
    maintainers = with lib.maintainers; [ oluceps ];
  };
}
