{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  nixosTests,
  makeWrapper,
  gawk,
  glibc,
}:

buildGoModule rec {
  pname = "vault";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    hash = "sha256-NXDxWEy7LqGTvMQn7U/80f3aJYA/UYQfk1BqhYRR9IY=";
  };

  vendorHash = "sha256-T0dJmFAgFq7Z/C0YUkoIeIt4FjfX5d8++4R0hR1qOCE=";

  proxyVendor = true;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  tags = [ "vault" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/vault/sdk/version.GitCommit=${src.rev}"
    "-X github.com/hashicorp/vault/sdk/version.Version=${version}"
    "-X github.com/hashicorp/vault/sdk/version.VersionPrerelease="
  ];

  postInstall =
    ''
      echo "complete -C $out/bin/vault vault" > vault.bash
      installShellCompletion vault.bash
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/vault \
        --prefix PATH ${
          lib.makeBinPath [
            gawk
            glibc
          ]
        }
    '';

  passthru.tests = {
    inherit (nixosTests)
      vault
      vault-postgresql
      vault-dev
      vault-agent
      ;
  };

  meta = with lib; {
    homepage = "https://www.vaultproject.io/";
    description = "Tool for managing secrets";
    changelog = "https://github.com/hashicorp/vault/blob/v${version}/CHANGELOG.md";
    license = licenses.bsl11;
    mainProgram = "vault";
    maintainers = with maintainers; [
      rushmorem
      lnl7
      offline
      pradeepchhetri
      Chili-Man
      techknowlogick
    ];
  };
}
