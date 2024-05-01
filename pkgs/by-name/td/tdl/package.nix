{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "tdl";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${version}";
    hash = "sha256-bIDgxCv9jSN3OxS0FydFwfJYr8BUQ+8U/0s2BkM4M70=";
  };

  vendorHash = "sha256-uCQ5HixoChppLO9kJvMWVENhHDnQsEe/qiJnbwUjE70=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/iyear/tdl/pkg/consts.Version=${version}"
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "A Telegram downloader/tools written in Golang";
    homepage = "https://github.com/iyear/tdl";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Ligthiago ];
    mainProgram = "tdl";
  };
}
