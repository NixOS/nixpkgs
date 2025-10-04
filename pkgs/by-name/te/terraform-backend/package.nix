{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "terraform-backend";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "nimbolus";
    repo = "terraform-backend";
    tag = "v${version}";
    hash = "sha256-S3ih7dLSQs3xJMHyQyWy43OG1maizBPVT8IsrWcSRUM=";
  };

  vendorHash = "sha256-5L8MNhjEPI3OOmtHdkB9ZQp02d7nzPp5h0/gVHTiCws=";

  ldflags = [
    "-s"
    "-w"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp "$GOPATH/bin/cmd" $out/bin/terraform-backend
    runHook postInstall
  '';

  meta = {
    description = "A state backend server which implements the Terraform HTTP backend API with pluggable modules for authentication, storage, locking and state encryption";
    homepage = "https://github.com/nimbolus/terraform-backend";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "terraform-backend";
  };
}
