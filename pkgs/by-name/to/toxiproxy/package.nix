{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  toxiproxy,
}:

buildGoModule rec {
  pname = "toxiproxy";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "toxiproxy";
    rev = "v${version}";
    sha256 = "sha256-CqJr3h2n+fzN6Ves38H7fYXd5vlpDVfF3kg4Tr8ThPc=";
  };

  vendorHash = "sha256-4nKWTjB9aV5ILgHVceV76Ip0byBxlEY5TTAQwNLvL2s=";

  excludedPackages = [ "test/e2e" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Shopify/toxiproxy/v2.Version=${version}"
  ];

  # Fixes tests on Darwin
  __darwinAllowLocalNetworking = true;

  checkFlags = [
    "-short"
    "-skip=TestVersionEndpointReturnsVersion|TestFullstreamLatencyBiasDown"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/toxiproxy-cli
    mv $out/bin/server $out/bin/toxiproxy-server
  '';

  passthru.tests = {
    cliVersion = testers.testVersion {
      inherit version;
      package = toxiproxy;
      command = "${toxiproxy}/bin/toxiproxy-cli -version";
    };
    serverVersion = testers.testVersion {
      inherit version;
      package = toxiproxy;
      command = "${toxiproxy}/bin/toxiproxy-server -version";
    };
  };

  meta = {
    changelog = "https://github.com/Shopify/toxiproxy/releases/tag/v${version}";
    description = "Proxy for for simulating network conditions";
    homepage = "https://github.com/Shopify/toxiproxy";
    maintainers = with lib.maintainers; [ avnik ];
    license = lib.licenses.mit;
  };
}
