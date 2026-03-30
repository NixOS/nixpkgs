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
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "isometry";
    repo = "vault-ssh-plus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-soz4xXVLyR479d+qcLuHq06CZ5afy+jqyIEZblyRlC0=";
  };

  vendorHash = "sha256-eHhs+6sPKkAdMWzh51ICfuejxwqEGeTNSI3P0X4BFSY=";

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
