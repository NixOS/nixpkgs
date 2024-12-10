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
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YxozhEJh/KBirlA6ymIEbJY3r7wYSeTL40W2xQLyue0=";
  };

  cargoHash = "sha256-l9oBwnI26hUgc0hStd7piYc4XD+9nFX6ylScmlhbA0w=";

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

  meta = {
    description = "WCH-Link flash tool for WCH's RISC-V MCUs(CH32V, CH56X, CH57X, CH58X, CH59X, CH32L103, CH32X035, CH641, CH643)";
    homepage = "https://github.com/ch32-rs/wlink";
    changelog = "https://github.com/ch32-rs/wlink/releases/tag/v${version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = !stdenv.hostPlatform.isLinux;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "wlink";
  };
}
