{
  lib,
  buildGoModule,
  fetchFromGitHub
}: buildGoModule rec {
  pname = "wifitui";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "greedoftheendless";
    repo = "wifitui-nix";
    rev = "main";
    hash = "sha256-pB+FmnkDfnOSD4319QP867cV9Bu8VWublEd48iTx27c=";
  };

  vendorHash = "sha256-SEQPc13cefzT8SyuD3UmNtTDgcrXUGTX54SBrnOHJJw=";

  meta = with lib; {
    description = "A TUI for managing Wi-Fi connections";
    homepage = "https://github.com/greedoftheendless/wifitui-nix";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
