{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tfsec";
  version = "1.28.14";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "tfsec";
    tag = "v${version}";
    hash = "sha256-8nZU7CjeKfpx1Fl3YtuQepW0LAG9/ng+8bMkoT1xmCQ=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aquasecurity/tfsec/version.Version=v${version}"
    ## not sure if this is needed (https://github.com/aquasecurity/tfsec/blob/master/.goreleaser.yml#L6)
    # "-extldflags '-fno-PIC -static'"
  ];

  vendorHash = "sha256-SuXrZNjr+x4uIA8fIae/9kypH/GDDKaiymD12xJvIFw=";

  subPackages = [
    "cmd/tfsec"
    "cmd/tfsec-docs"
    "cmd/tfsec-checkgen"
  ];

  meta = {
    description = "Static analysis powered security scanner for terraform code";
    homepage = "https://github.com/aquasecurity/tfsec";
    changelog = "https://github.com/aquasecurity/tfsec/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
    ];
  };
}
