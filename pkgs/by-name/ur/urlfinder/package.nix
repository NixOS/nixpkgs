{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "urlfinder";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "urlfinder";
    rev = "refs/tags/v${version}";
    hash = "sha256-dtCXCRnI05822+a5Os+I+ZAmL/hC884PRCIPlEY3jok=";
  };

  vendorHash = "sha256-9sIBj1K4N+HTd0OWnhP8+T1pPG9un8+FlpbPFwsV8P8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool for passively gathering URLs without active scanning";
    homepage = "https://github.com/projectdiscovery/urlfinder";
    changelog = "https://github.com/projectdiscovery/urlfinder/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "urlfinder";
  };
}
