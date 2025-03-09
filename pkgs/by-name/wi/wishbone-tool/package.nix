{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libusb-compat-0_1,
}:

let
  version = "0.7.9";
  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "wishbone-utils";
    rev = "v${version}";
    hash = "sha256-Gl0bxHJ8Y0ytYJxToYAR2tVkD4YNMihk+zRpieSvMGE=";
  };
in
rustPlatform.buildRustPackage {
  pname = "wishbone-tool";
  inherit version;

  inherit src;

  sourceRoot = "${src.name}/wishbone-tool";

  cargoHash = "sha256-wOw3v47AekJUW+8dpHVysheA+42HwEahn/hriYF7CfA=";

  buildInputs = [ libusb-compat-0_1 ];

  meta = with lib; {
    description = "Manipulate a Wishbone device over some sort of bridge";
    mainProgram = "wishbone-tool";
    homepage = "https://github.com/litex-hub/wishbone-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ edef ];
    platforms = platforms.linux;
  };
}
