{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  tf-summarize,
}:

buildGoModule (finalAttrs: {
  pname = "tf-summarize";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "dineshba";
    repo = "tf-summarize";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yjketL/7+gsWIvltqotouSNgTCBOqVrHqiblXoCsWgI=";
  };

  vendorHash = "sha256-e17oCuvPkPAJGPhFoaNZ5Bl4/OoVujkNII1akuQviE0=";

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
