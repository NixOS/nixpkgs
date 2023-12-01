{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "starlark";
  version = "unstable-2023-11-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "556fd59b42f68a2fb1f84957741b72811c714e51";
    hash = "sha256-0IiEtZOQEvE2Qm//lI1eyFFL1q/ZQzO9JzmiGsk0HkQ=";
  };

  vendorHash = "sha256-jQE5fSqJeiDV7PW7BY/dzCxG6b/KEVIobcjJsaL2zMw=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/google/starlark-go";
    description = "An interpreter for Starlark, implemented in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
