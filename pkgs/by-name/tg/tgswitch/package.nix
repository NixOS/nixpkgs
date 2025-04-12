{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tgswitch";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "tgswitch";
    rev = version;
    sha256 = "sha256-Q3Cef3B7hfVHLvW8Rx6IdH9g/3luDhpUMZ8TXVpb8gQ=";
  };

  vendorHash = "sha256-PlTdbA8Z2I2SWoG7oYG87VQfczx9zP1SCJx70UWOEog=";

  ldflags = [
    "-s"
    "-w"
  ];

  # There are many modifications need to be done to make tests run. For example:
  # 1. Network access
  # 2. Operation on `/var/empty` not permitted on macOS
  doCheck = false;

  meta = with lib; {
    description = "Command line tool to switch between different versions of terragrunt";
    mainProgram = "tgswitch";
    homepage = "https://github.com/warrensbox/tgswitch";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
