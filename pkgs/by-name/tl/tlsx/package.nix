{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tlsx";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "tlsx";
    tag = "v${version}";
    hash = "sha256-u83hPmmiXH7SGCyINkHFrjNDLanwJLf0o9ZyceQeSg0=";
  };

  vendorHash = "sha256-NF05vVLBRlWQpmTfrNEjnvH7kZMhgY73xmSgTZ8FGmo=";

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
