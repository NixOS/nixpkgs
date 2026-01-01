{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,
  testers,
  telegraf,
}:

buildGoModule rec {
  pname = "telegraf";
<<<<<<< HEAD
  version = "1.37.0";
=======
  version = "1.36.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8PacuXxxGv4bjmkY8mtPjyycaUvnNtMu8XtOgKhKpNo=";
  };

  vendorHash = "sha256-22XtJ+V859xk0DGPJFVtuaqn91QC8ag1EWR653QuAA4=";
=======
    hash = "sha256-sqFknEDhBR370w7MRHV34mz/j+TNzY2+vNDqouDAiwA=";
  };

  vendorHash = "sha256-8Dtztt5Z8Wn2ZsDCOJ5NiID6w3/xNXwEy0WnQYNwFg4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/influxdata/telegraf/internal.Commit=${src.rev}"
    "-X=github.com/influxdata/telegraf/internal.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = telegraf;
    };
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit (nixosTests) telegraf;
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Plugin-driven server agent for collecting & reporting metrics";
    mainProgram = "telegraf";
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    changelog = "https://github.com/influxdata/telegraf/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mic92
      roblabla
      timstott
      zowoq
    ];
  };
}
