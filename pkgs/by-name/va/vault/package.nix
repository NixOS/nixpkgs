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
<<<<<<< HEAD
  version = "1.21.1";
=======
  version = "1.20.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Vkn3l4blbUhT2D1ParNacVwwt/aDQlm12peoHvPNbk4=";
  };

  vendorHash = "sha256-8IK8M328dXWk+NHjK7d+Zj8ltLQqJOofvLDfDieDFnk=";
=======
    hash = "sha256-GZ+/NzOjcKTYOq4HajKGD68RNxIdXxfLo/pAewaZ8F8=";
  };

  vendorHash = "sha256-mhT5s1nIdX/57TDEaWwbni0E7DX0W0WwwvrSr7L66hI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  proxyVendor = true;

  postPatch = ''
    # Remove defunct github.com/hashicorp/go-cmp dependency
    sed -i '/github\.com\/hashicorp\/go-cmp/d' go.mod
    sed -i '/github\.com\/hashicorp\/go-cmp/d' go.sum
  '';

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

  postInstall = ''
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

  meta = {
    homepage = "https://www.vaultproject.io/";
    description = "Tool for managing secrets";
    changelog = "https://github.com/hashicorp/vault/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsl11;
    mainProgram = "vault";
    maintainers = with lib.maintainers; [
      rushmorem
      lnl7
      offline
      Chili-Man
      techknowlogick
    ];
  };
}
