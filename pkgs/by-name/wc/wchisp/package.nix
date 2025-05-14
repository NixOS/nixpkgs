{
  stdenv,
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libusb1,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "wchisp";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-6WNXsRvbldEjAykMn1DCiuKctBrsTHGv1fJuRXBblu0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VC8wiMdg7BnE92m57pKSrtv7vmbRNwV1yyy3f+1e+cY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libusb1
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A command-line implementation of WCHISPTool, for flashing ch32 MCUs";
    homepage = "https://ch32-rs.github.io/wchisp/";
    changelog = "https://github.com/ch32-rs/wchisp/releases/tag/v${version}";
    license = with lib.licenses; [ gpl2Only ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = !stdenv.hostPlatform.isLinux;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "wchisp";
  };
}
