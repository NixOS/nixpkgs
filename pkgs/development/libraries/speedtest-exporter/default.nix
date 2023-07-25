{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "speedtest-exporter";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "nlamirault";
    repo = "speedtest_exporter";
    rev = "v${version}";
    hash = "sha256-WIMDv63sHyZVw3Ct5LFXCIufj7sU2H81n+hT/NiPMeQ=";
  };

  vendorHash = "sha256-Lm73pZzdNZv7J+vKrtQXxm4HiAuB9lugKT/oanmD0HM=";

  meta = with lib; {
    description = "Prometheus exporter for Speedtest metrics";
    homepage = "https://github.com/nlamirault/speedtest_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "speedtest_exporter";
  };
}
