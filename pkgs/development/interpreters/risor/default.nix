{ lib
, buildGoModule
, fetchFromGitHub
, testers
, risor
}:

buildGoModule rec {
  pname = "risor";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${version}";
    hash = "sha256-aBUM/+mAuQ+JUOqeMtRYpOwdKbD6An9/Nc2Q6YDnUmE=";
  };

  sourceRoot = "${src.name}/cmd/risor";

  vendorHash = "sha256-vlrYmY70nEAI8FSsMzZtuLMt8+aVi0jDX7PGKRMw4r8=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = risor;
      command = "risor version";
    };
  };

  meta = with lib; {
    description = "Fast and flexible scripting for Go developers and DevOps";
    homepage = "https://github.com/risor-io/risor";
    changelog = "https://github.com/risor-io/risor/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
