{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, go
, testers
, terraform-plugin-docs
, nix-update-script
}:

buildGoModule rec {
  pname = "terraform-plugin-docs";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-plugin-docs";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-5vbi69GMgkzvN3aEQbNTbk99rg+kfvAvUrdDsuyIm9s=";
  };

  vendorHash = "sha256-AjW6BokLVDkIWXToJ7wNq/g19xKTAfpQ/gVlKCV5qw0=";

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [
    "cmd/tfplugindocs"
  ];

  allowGoReference = true;

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
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

  meta = with lib; {
    description = "Generate and validate Terraform plugin/provider documentation";
    homepage = "https://github.com/hashicorp/terraform-plugin-docs";
    changelog = "https://github.com/hashicorp/terraform-plugin-docs/releases/tag/v${version}";
    license = licenses.mpl20;
    mainProgram = "tfplugindocs";
    maintainers = with maintainers; [ lewo ];
  };
}
