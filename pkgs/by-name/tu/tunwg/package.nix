{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tunwg";
  version = "25.11.15+bbd247b";

  src = fetchFromGitHub {
    owner = "ntnj";
    repo = "tunwg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1NWxVrah3AJPgFxaWJomEs4SAt0Eql3rXG1AaClJMkY=";
  };

  vendorHash = "sha256-qYSSqynT+XLK5Gb3X9dmAbGKxTTN0C71p6QtrlovgJY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Secure private tunnel to your local servers";
    homepage = "https://github.com/ntnj/tunwg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "tunwg";
  };
})
