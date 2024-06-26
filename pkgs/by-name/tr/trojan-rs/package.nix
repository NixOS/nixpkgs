{ fetchFromGitHub
, rustPlatform
, lib
, ipset
}:

rustPlatform.buildRustPackage {
  pname = "trojan-rs";
  version = "0.16.0-unstable-2024-02-18";

  src = fetchFromGitHub {
    owner = "lazytiger";
    repo = "trojan-rs";
    rev = "161840e3ff40e82701aa95fd168e929744e35cdd";
    hash = "sha256-9c90WDP1TuNZwA3jOqwAqpSJzbFpPMtNUYUXSncJgKg=";
  };

  cargoHash = "sha256-ZWVkdU+e/X/io1Sb2epugg0Qv5vgrsnB9UuuT0VpKi4=";

  buildInputs = [ ipset ];

  RUSTC_BOOTSTRAP = true;
  RUSTFLAGS = "--cfg tokio_unstable";

  meta = with lib; {
    homepage = "https://github.com/lazytiger/trojan-rs";
    description = "Trojan server and proxy programs written in Rust";
    license = licenses.mit;
    mainProgram = "trojan";
    maintainers = with maintainers; [ oluceps ];
  };
}
