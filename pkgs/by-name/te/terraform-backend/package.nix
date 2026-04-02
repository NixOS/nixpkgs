{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-backend";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nimbolus";
    repo = "terraform-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8tC5g0qqKWYQlzu8ZEMCbxkaZ0nP5Z2GuSkRA+9SFwU=";
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

  meta = {
    description = "State backend server which implements the Terraform HTTP backend API with pluggable modules for authentication, storage, locking and state encryption";
    homepage = "https://github.com/nimbolus/terraform-backend";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "terraform-backend";
  };
})
