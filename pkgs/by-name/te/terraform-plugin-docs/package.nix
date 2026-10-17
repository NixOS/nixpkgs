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

buildGoModule (finalAttrs: {
  pname = "terraform-plugin-docs";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-plugin-docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QgN2gcGu9Laq4gQkYBvbE7gadiwzAyERLaKVLI+XiHQ=";
  };

  vendorHash = "sha256-+D3JwUpLJ6gZAkTFO0fQAFpl0OCp36HMbWES/+lK+9g=";

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [
    "cmd/tfplugindocs"
  ];

  allowGoReference = true;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/terraform-plugin-docs/cmd/tfplugindocs/build.version=${finalAttrs.version}"
    "-X github.com/hashicorp/terraform-plugin-docs/cmd/tfplugindocs/build.commit=${finalAttrs.src.tag}"
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
    changelog = "https://github.com/hashicorp/terraform-plugin-docs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    mainProgram = "tfplugindocs";
    maintainers = with lib.maintainers; [ lewo ];
  };
})
