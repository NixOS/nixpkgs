{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "virter";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "LINBIT";
    repo = "virter";
    rev = "v${version}";
    hash = "sha256-38qnXbOy5s0MEVyE7bZKXxQHt4xqv+cV/o40DSPxc6w=";
  };

  vendorHash = "sha256-ygmXt6AyVIN0bnXza5+epk4SYCeMBPMU76t9pTcTntE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/LINBIT/virter/cmd.version=${version}"
    "-X github.com/LINBIT/virter/cmd.builddate=builtByNix"
    "-X github.com/LINBIT/virter/cmd.githash=builtByNix"
  ];

  # requires network access
  doCheck = false;

  meta = {
    description = "Command line tool for simple creation and cloning of virtual machines based on libvirt";
    homepage = "https://github.com/LINBIT/virter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "virter";
  };
}
