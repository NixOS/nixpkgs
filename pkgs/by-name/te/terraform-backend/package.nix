{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-backend";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nimbolus";
    repo = "terraform-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2dqUkrBRkOKuEfoj8nvZrTCguiC3Vqw5gamPjR3Ql3w=";
  };

  vendorHash = "sha256-tA/Ohm44lBtS4CyW2+8qCgyea0eiIV3631wNucVigeA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nimbolus/terraform-backend/pkg/version.Version=v${finalAttrs.version}"
  ];

  # this test wants a version name without `ldflags`
  postPatch = ''
    substituteInPlace pkg/server/migration_test.go \
      --replace-fail '"dev", s.Metadata.TerraformBackendVersion' '"v${finalAttrs.version}", s.Metadata.TerraformBackendVersion'
  '';

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
