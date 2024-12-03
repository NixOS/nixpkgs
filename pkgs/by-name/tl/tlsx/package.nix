{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tlsx";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "tlsx";
    rev = "refs/tags/v${version}";
    hash = "sha256-AQiwHNHfwOJYIEsFm2YiksdTUxp5vkCL80rpvxHY2rA=";
  };

  vendorHash = "sha256-KNyB+xK7TUf7XoVX/4xBTnG2lMMPVV5AOoUNi4aA/cM=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "TLS grabber focused on TLS based data collection";
    longDescription = ''
      A fast and configurable TLS grabber focused on TLS based data
      collection and analysis.
    '';
    homepage = "https://github.com/projectdiscovery/tlsx";
    changelog = "https://github.com/projectdiscovery/tlsx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
