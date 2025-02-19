{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  timer,
}:

buildGoModule rec {
  pname = "timer";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "timer";
    rev = "v${version}";
    hash = "sha256-nHQPTinrSXMeZeiZC16drliFf0ib9+gjxJr9oViZqOc=";
  };

  vendorHash = "sha256-mE/C4S2gqcFGfnmCeMS/VpQwXHrI8SXos0M1+rV3hPo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion { package = timer; };

  meta = with lib; {
    description = "`sleep` with progress";
    homepage = "https://github.com/caarlos0/timer";
    license = licenses.mit;
    maintainers = with maintainers; [
      zowoq
      caarlos0
    ];
    mainProgram = "timer";
  };
}
