{
  buildGoModule,
  fetchFromGitHub,
  lib,

}:

buildGoModule rec {
  pname = "pkger";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "markbates";
    repo = "pkger";
    rev = "v${version}";
    hash = "sha256-nBuOC+uVw+hYSssgTkPRJZEBkufhQgU5D6jsZZre7Is=";
  };

  vendorHash = "sha256-9+2s84bqoNU3aaxmWYzIuFKPA3Tw9phXu5Csaaq/L60=";

  doCheck = false;

  meta = with lib; {
    description = "Embed static files in Go binaries (replacement for gobuffalo/packr) ";
    mainProgram = "pkger";
    homepage = "https://github.com/markbates/pkger";
    changelog = "https://github.com/markbates/pkger/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
