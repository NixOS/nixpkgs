{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  xq-xml,
}:

buildGoModule (finalAttrs: {
  pname = "xq";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KLpf4db3D+SQzbitc9ROO+k/VHggWpwZmwwhV3QVNiE=";
  };

  vendorHash = "sha256-LKkYA0wZ+MQ67Gox2e+iuWSgbxF0daJj7RWLA6C+v+I=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = xq-xml;
    };
  };

  meta = {
    description = "Command-line XML and HTML beautifier and content extractor";
    mainProgram = "xq";
    homepage = "https://github.com/sibprogrammer/xq";
    changelog = "https://github.com/sibprogrammer/xq/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
