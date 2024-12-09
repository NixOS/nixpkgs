{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    rev = "v${version}";
    hash = "sha256-ua2tFyOjLeqOpipLoSisASqwjqGEFdkxd2qHybZ1VDU=";
  };

  vendorHash = "sha256-JweKjKvShiimFHQwRtoVuongWqqGIPcPz77qEVNec+M=";

  patches = [./go-mod.patch];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/homeport/termshot/internal/cmd.version=${version}"
  ];

  meta = {
    description = "Creates screenshots based on terminal command output";
    homepage = "https://github.com/homeport/termshot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [defelo];
    mainProgram = "termshot";
  };
}
