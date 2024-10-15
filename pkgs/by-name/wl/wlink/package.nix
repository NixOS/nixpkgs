{
  stdenv,
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libusb1,
  udev,
  nix-update-script,
  testers,
  wlink,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlink";
  version = "0.0.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Jr494jsw9nStU88j1rHc3gyQR1jcMfDIyQ2u0SwkXt0=";
  };

  cargoHash = "sha256-rPiSEfRFESYxFOat92oMUABvmz0idZu/I1S7I3g5BgY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libusb1
    udev
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = wlink;
    };
  };

  meta = with lib; {
    description = "WCH-Link flash tool for WCH's RISC-V MCUs(CH32V, CH56X, CH57X, CH58X, CH59X, CH32L103, CH32X035, CH641, CH643)";
    homepage = "https://github.com/ch32-rs/wlink";
    changelog = "https://github.com/ch32-rs/wlink/releases/tag/v${version}";
    license = with licenses; [
      mit # or
      asl20
    ];
    platforms = with platforms; linux ++ darwin ++ windows;
    broken = !stdenv.hostPlatform.isLinux;
    maintainers = with maintainers; [ jwillikers ];
    mainProgram = "wlink";
  };
}
