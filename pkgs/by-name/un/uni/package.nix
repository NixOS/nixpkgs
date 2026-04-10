{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "uni";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "uni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j7uqxXDFCBbLLOVGKlUEsDdryGkZ6n08E4jZgWtCwJs=";
  };

  vendorHash = "sha256-Jox5uuQactffBJDDxhlCWKzPh0fKL7bLh22ARJBgSII=";

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
