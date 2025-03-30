{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  timer,
}:

buildGoModule rec {
  pname = "timer";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "timer";
    rev = "v${version}";
    hash = "sha256-Y4goNURzWl3DGeR14jEB87IJSNhSRqoF+/7zjGQ+19E=";
  };

  vendorHash = "sha256-RMVlCWPezi0mCq3hsJrEHK5pw7dN/wnLHFYvmxaNCBM=";

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
