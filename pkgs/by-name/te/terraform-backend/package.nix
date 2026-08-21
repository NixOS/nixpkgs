{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-backend";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "nimbolus";
    repo = "terraform-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JRIX1el61/E+7djbK8tTzrFMgI0ugMsj7Ydj9UE2s+E=";
  };

  vendorHash = "sha256-2krZ1JVioWiVuAGflMzw0W0wITpHTMu8j1Kio+uCkvM=";

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

  passthru.tests = {
    nixos = nixosTests.terraform-backend;
  };

  meta = {
    description = "State backend server which implements the Terraform HTTP backend API with pluggable modules for authentication, storage, locking and state encryption";
    homepage = "https://github.com/nimbolus/terraform-backend";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "terraform-backend";
  };
})
