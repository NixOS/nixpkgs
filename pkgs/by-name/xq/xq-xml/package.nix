{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  xq-xml,
}:

buildGoModule (finalAttrs: {
  pname = "xq";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6iC5YhCppzlyp6o+Phq98gQj4LjQx/5pt2+ejOvGvTE=";
  };

  vendorHash = "sha256-EYAFp9+tiE0hgTWewmai6LcCJiuR+lOU74IlYBeUEf0=";

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
