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
  version = "1.21.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    hash = "sha256-G/6GroX9lBaUxB5mkd+hz53nNX/eF5DAtHryin3hzgU=";
  };

  vendorHash = "sha256-bJdEQkJnUiPI6MSVAsLCqDSsM4zuT5ORJ93jVC+EEAs=";

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
      Chili-Man
      techknowlogick
    ];
  };
}
