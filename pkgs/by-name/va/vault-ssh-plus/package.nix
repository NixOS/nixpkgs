{
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  lib,
  openssh,
  testers,
  vault-ssh-plus,
}:
buildGoModule (finalAttrs: {
  pname = "vault-ssh-plus";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "isometry";
    repo = "vault-ssh-plus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5rajB4pSRp7Pw4yx0u6MoOLxfkWWjhB7T2JGGb8ICRU=";
  };

  vendorHash = "sha256-IfT8F8zqWSfGh/XlISDTTZju8i3dEHG33lrZqJz1nX8=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/vault-ssh-plus $out/bin/vssh
    wrapProgram $out/bin/vssh --prefix PATH : ${lib.makeBinPath [ openssh ]};
  '';

  passthru.tests.version = testers.testVersion {
    package = vault-ssh-plus;
    command = "vssh --version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    homepage = "https://github.com/isometry/vault-ssh-plus";
    changelog = "https://github.com/isometry/vault-ssh-plus/releases/tag/v${finalAttrs.version}";
    description = "Automatically use HashiCorp Vault SSH Client Key Signing with ssh(1)";
    mainProgram = "vssh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
  };
})
