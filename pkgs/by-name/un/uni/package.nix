{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "uni";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "uni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+n+QExNCk5QsavO0Kj/e12v4xFJDnXprJGjyk2i/ioY=";
  };

  vendorHash = "sha256-8nl7iFMmoGuC3pEVi6HqXdwFCKvCDi3DMwRQFjfBC7Y=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/arp242/uni";
    description = "Query the Unicode database from the commandline, with good support for emojis";
    changelog = "https://github.com/arp242/uni/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chvp ];
    mainProgram = "uni";
  };
})
