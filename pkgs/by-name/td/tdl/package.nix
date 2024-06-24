{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "tdl";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${version}";
    hash = "sha256-qyoZqd6VLiq8L4p4ubKIM6HWJdn7SaQDQN9kIArbnls=";
  };

  vendorHash = "sha256-Xfd98qce/xThwF+dssNznny8FgrORGsAhDALfW9bWEQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/iyear/tdl/pkg/consts.Version=${version}"
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Telegram downloader/tools written in Golang";
    homepage = "https://github.com/iyear/tdl";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Ligthiago ];
    mainProgram = "tdl";
  };
}
