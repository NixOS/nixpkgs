{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    rev = "v${version}";
    hash = "sha256-Sxp6abYq0MrqtqDdpffSBdZB3/EyIMF9Ixsc7IgW5hI=";
  };

  vendorHash = "sha256-jzDbA1iN+1dbTVgKw228TuCV3eeAVmHFDiHd2qF/80E=";

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
