{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tf-summarize
}:

buildGoModule rec {
  pname = "tf-summarize";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "dineshba";
    repo = "tf-summarize";
    rev = "v${version}";
    hash = "sha256-yjketL/7+gsWIvltqotouSNgTCBOqVrHqiblXoCsWgI=";
  };

  vendorHash = "sha256-e17oCuvPkPAJGPhFoaNZ5Bl4/OoVujkNII1akuQviE0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = tf-summarize;
    command = "tf-summarize -v";
    inherit version;
  };

  meta = with lib; {
    description = "Command-line utility to print the summary of the terraform plan";
    mainProgram = "tf-summarize";
    homepage = "https://github.com/dineshba/tf-summarize";
    license = licenses.mit;
    maintainers = with maintainers; [ pjrm ];
  };
}
