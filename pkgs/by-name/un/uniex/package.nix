{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "uniex";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "uniex";
    tag = "v${version}";
    hash = "sha256-SYYpLE43vpMpM2ggk9QhwQoQ2a7ISM2bRyWKrATtw5o=";
  };

  vendorHash = "sha256-JC8ihhdogyeeQ6BaLDoxzQ5VnK9zQ+Mc2Z68z4WvcE8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/paepckehh/uniex/releases/tag/v${version}";
    homepage = "https://paepcke.de/uniex";
    description = "Tool to export unifi network controller mongodb asset information [csv|json].";
    license = lib.licenses.bsd3;
    mainProgram = "uniex";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
