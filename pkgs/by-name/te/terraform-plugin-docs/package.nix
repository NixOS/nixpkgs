{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  go,
  testers,
  terraform-plugin-docs,
  nix-update-script,
}:

buildGoModule rec {
  pname = "terraform-plugin-docs";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-plugin-docs";
    tag = "v${version}";
    hash = "sha256-tvo5ufRBtiecOCHfGO9Sxe+bHXqgnfGhBaQQ47CVllk=";
  };

  vendorHash = "sha256-y69F/KF7cQvtZ4/ZNpw86l/xZgn4aTzmVBw1bs+AtZI=";

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [
    "cmd/tfplugindocs"
  ];

  allowGoReference = true;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/terraform-plugin-docs/cmd/tfplugindocs/build.version=${version}"
    "-X github.com/hashicorp/terraform-plugin-docs/cmd/tfplugindocs/build.commit=${src.tag}"
  ];

  postInstall = ''
    wrapProgram $out/bin/tfplugindocs --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  passthru = {
    tests.version = testers.testVersion {
      command = "tfplugindocs --version";
      package = terraform-plugin-docs;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Generate and validate Terraform plugin/provider documentation";
    homepage = "https://github.com/hashicorp/terraform-plugin-docs";
    changelog = "https://github.com/hashicorp/terraform-plugin-docs/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    mainProgram = "tfplugindocs";
    maintainers = with lib.maintainers; [ lewo ];
  };
}
