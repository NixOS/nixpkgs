{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "unparam";
  version = "0-unstable-2026-11-02";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "unparam";
    rev = "394cd0a56cd513bd0494ee5c8fca9672653b183d";
    hash = "sha256-TDDofymP/5kbzTKcSCh8Ez9KSD6Z/LQR88Eq5CmYmeo=";
  };

  vendorHash = "sha256-txYjynxJzaXd6vUgc0rh4kj7+bq1BArqm+dz9b4oKFI=";

  subPackages = [ "." ];

  meta = {
    description = "Find unused parameters in Go";
    homepage = "https://github.com/mvdan/unparam";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "unparam";
  };
}
