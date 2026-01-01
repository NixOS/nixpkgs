{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ticker,
  testers,
}:

buildGoModule rec {
  pname = "ticker";
<<<<<<< HEAD
  version = "5.2.0";
=======
  version = "5.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = "ticker";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GH+2as3aK462cTguGekbB4HchVzC1HdBsXwJHwAh47Q=";
=======
    hash = "sha256-/W/BZzrIkz/3F2jzQGJ79UycrdEBVTMF+YncCS5TibE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-EKc9QRDSOD4WetCXORjMUlaFqh0+B3Aa3m5SR1WiKN4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/v${lib.versions.major version}/cmd.Version=${version}"
  ];

  # Tests require internet
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = ticker;
    command = "ticker --version";
    inherit version;
  };

  meta = {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    changelog = "https://github.com/achannarasappa/ticker/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      siraben
      sarcasticadmin
    ];
    mainProgram = "ticker";
  };
}
