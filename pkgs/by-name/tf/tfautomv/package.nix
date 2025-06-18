{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tfautomv";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "busser";
    repo = "tfautomv";
    rev = "v${version}";
    hash = "sha256-/bwCP8HViGQr3kLVQxHOg7bhNwe2D+wif96IdcHD4nk=";
  };

  # checks require unfree programs like terraform/terragrunt
  doCheck = false;

  vendorHash = "sha256-7BjytBX52xB8ThneBoSV6sEVcknQMs776D3nY7ckrBM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/busser/tfautomv";
    description = "When refactoring a Terraform codebase, you often need to write moved blocks. This can be tedious. Let tfautomv do it for you";
    mainProgram = "tfautomv";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
