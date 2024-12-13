{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tdl";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${version}";
    hash = "sha256-/aZ85FLGlNVfHG/LyfbvxBdZlne/s3ktw7RNmKeNSeI=";
  };

  vendorHash = "sha256-o1GVra4kbjkLtFkoqK+8We/Ov+JHsEI+4jJYX5tPimM=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/iyear/tdl/pkg/consts.Version=${version}"
  ];

  # Filter out the main executable
  subPackages = [ "." ];

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
