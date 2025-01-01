{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xc";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eaFHK7VsfLSgSJehv4urxq8qMPT+zzs2tRypz4q+MLc=";
  };

  vendorHash = "sha256-EbIuktQ2rExa2DawyCamTrKRC1yXXMleRB8/pcKFY5c=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    description = "Markdown defined task runner";
    mainProgram = "xc";
    homepage = "https://xcfile.dev/";
    changelog = "https://github.com/joerdav/xc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      joerdav
    ];
  };
}
