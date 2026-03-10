{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  timer,
}:

buildGoModule (finalAttrs: {
  pname = "timer";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "timer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y4goNURzWl3DGeR14jEB87IJSNhSRqoF+/7zjGQ+19E=";
  };

  vendorHash = "sha256-RMVlCWPezi0mCq3hsJrEHK5pw7dN/wnLHFYvmxaNCBM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion { package = timer; };

  meta = {
    description = "`sleep` with progress";
    homepage = "https://github.com/caarlos0/timer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zowoq
      caarlos0
    ];
    mainProgram = "timer";
  };
})
