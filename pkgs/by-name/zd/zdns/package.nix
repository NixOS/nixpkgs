{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zdns";
  version = "2023-04-09-unstable";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    rev = "ac6c7f30a7f5e11f87779f5275adeed117227cd6";
    hash = "sha256-que2uzIH8GybU6Ekumg/MjgBHSmFCF+T7PWye+25kaY=";
  };

  vendorHash = "sha256-daMPk1TKrUXXqCb4WVkrUIJsBL7uzXLJnxWNbHQ/Im4=";

  meta = with lib; {
    description = "CLI DNS lookup tool";
    mainProgram = "zdns";
    homepage = "https://github.com/zmap/zdns";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
