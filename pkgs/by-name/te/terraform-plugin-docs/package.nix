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
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-plugin-docs";
    tag = "v${version}";
    hash = "sha256-ktYADQEUD3bb6JRUy/g4l2J3XBzCVbt/knLqsd/MnF8=";
  };

  vendorHash = "sha256-FKIBkg2fXO89GDTkHQeK4v2YWe870GAKgNiu12k3iS0=";

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
