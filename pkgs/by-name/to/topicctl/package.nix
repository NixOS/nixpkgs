{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "topicctl";
<<<<<<< HEAD
  version = "1.23.1";
=======
  version = "1.22.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-49byQWrv0yDPCAMcgltlDnmYZ5TWyTUIZy0K46CiTUs=";
  };

  vendorHash = "sha256-ltvWWB0Y5arPV8o3bSYHcDf1ZSRRCrPriXklShj/fjo=";
=======
    sha256 = "sha256-+PkqIO3xsShSTyi5yBa9a3zLU8BIwERlBv84nuk8rHI=";
  };

  vendorHash = "sha256-JGVieAp5pg+Vhqx/Ge6xkR3sm/e+qYjMYrkYcPZjpiA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      eskytthe
      srhb
    ];
    mainProgram = "topicctl";
  };
}
