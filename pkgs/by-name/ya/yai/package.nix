{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "yai";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ekkinox";
    repo = "yai";
    rev = finalAttrs.version;
    sha256 = "sha256-MoblXLfptlIYJbXQTpbc8GBo2a3Zgxdvwra8IUEGiZs==";
  };

  vendorHash = "sha256-+NhYK8FXd5B3GsGUPJOMM7Tt3GS1ZJ7LeApz38Xkwx8=";

  ldflags = [
    "-w -s"
    "-X main.buildVersion=${finalAttrs.version}"
  ];

  preCheck = ''
    # analyzer_test.go needs a user
    export USER=test
  '';

  meta = {
    homepage = "https://github.com/ekkinox/yai";
    description = "Your AI powered terminal assistant";
    longDescription = ''
      Yai (your AI) is an assistant for your terminal, using OpenAI ChatGPT to build and run commands for you.
      You just need to describe them in your everyday language, it will take care or the rest.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ georgesalkhouri ];
    mainProgram = "yai";
  };
})
