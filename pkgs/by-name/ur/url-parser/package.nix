{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${version}";
    hash = "sha256-Kwjub9qAfHhqNL3mRzlJws1wnwVPAJ3jPYh0s/cu7+8=";
  };

  vendorHash = "sha256-MR8SjQ8IrHC6hZTvmnqXvqJ6odo0+RIMDtMpYwY+iMs=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.BuildVersion=${version}"
    "-X"
    "main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    changelog = "https://github.com/thegeeklab/url-parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "url-parser";
  };
}
