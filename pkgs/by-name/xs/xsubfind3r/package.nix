{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xsubfind3r";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xsubfind3r";
    rev = "refs/tags/${version}";
    hash = "sha256-vmcuIa/ebCggLIALbfljJr92GE6veYEl3glm5gH9IZM=";
  };

  vendorHash = "sha256-PFeUO3LWNBF4KPSHBxRIczIMR002Xzydcy6FyjKP60A=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI utility to find subdomains from curated passive online sources";
    homepage = "https://github.com/hueristiq/xsubfind3r";
    changelog = "https://github.com/hueristiq/xsubfind3r/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "xsubfind3r";
  };
}
