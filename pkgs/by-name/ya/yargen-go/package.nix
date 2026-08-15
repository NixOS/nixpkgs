{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "yargen-go";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Neo23x0";
    repo = "yarGen-Go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XQNEyjiv2v5coBksHqrTG1rkdtjaUEGsHLr8REEKx3Y=";
  };

  vendorHash = "sha256-FltSHAvR1IJL5UlXf+Cxpmhdr35JTrPhB2flh0bbZAY=";

  subPackages = [
    "cmd/yargen"
    "cmd/yargen-util"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Automatic YARA rule generator (Go rewrite of yarGen)";
    longDescription = ''
      yarGen-Go generates YARA rules from strings found in malware
      samples while filtering out strings that also occur in goodware.
      It is a Go rewrite of the original Python yarGen by Florian Roth,
      and ships two binaries: yargen (CLI + web UI rule generator) and
      yargen-util (goodware database management).
    '';
    homepage = "https://github.com/Neo23x0/yarGen-Go";
    changelog = "https://github.com/Neo23x0/yarGen-Go/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "yargen";
  };
})
