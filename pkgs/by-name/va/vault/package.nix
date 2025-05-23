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
  version = "1.19.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    hash = "sha256-IF67/aWBUMFjAyC0TloKOJUa3zenk47QaCTBKwOltvw=";
  };

  vendorHash = "sha256-tVCSEqAlyogwFSBWtFEzDl5ziteoBexqQ0xaGmk8F+k=";

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
