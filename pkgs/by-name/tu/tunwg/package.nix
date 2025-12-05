{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tunwg";
  version = "25.11.15+bbd247b";

  src = fetchFromGitHub {
    owner = "ntnj";
    repo = "tunwg";
    rev = "v${version}";
    hash = "sha256-1NWxVrah3AJPgFxaWJomEs4SAt0Eql3rXG1AaClJMkY=";
  };

  vendorHash = "sha256-qYSSqynT+XLK5Gb3X9dmAbGKxTTN0C71p6QtrlovgJY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Secure private tunnel to your local servers";
    homepage = "https://github.com/ntnj/tunwg";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tunwg";
  };
}
