{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "walk";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "walk";
    rev = "v${version}";
    hash = "sha256-wGiRMNgp5NZVj8ILyQ2C/iqpjv4XgphRfWcF/CSMj48=";
  };

  vendorHash = "sha256-MTM7zR5OYHbzAm07FTLvXVnESARg50/BZrB2bl+LtXM=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/walk";
    license = licenses.mit;
    maintainers = with maintainers; [ portothree surfaceflinger ];
    mainProgram = "walk";
  };
}
