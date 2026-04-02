{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  tf-summarize,
}:

buildGoModule (finalAttrs: {
  pname = "tf-summarize";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "dineshba";
    repo = "tf-summarize";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m0XQkxcNW0QTYd3tPz9v13dsiI/jUV0eJW0Oo2vKKtk=";
  };

  vendorHash = "sha256-ncXJCOmpf6cuZd7JouAlyae/+pbjmlByrT3Z32EZEhc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = tf-summarize;
    command = "tf-summarize -v";
    inherit (finalAttrs) version;
  };

  meta = {
    description = "Command-line utility to print the summary of the terraform plan";
    mainProgram = "tf-summarize";
    homepage = "https://github.com/dineshba/tf-summarize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pjrm ];
  };
})
