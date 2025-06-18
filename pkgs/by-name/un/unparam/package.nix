{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "unparam";
  version = "0-unstable-2025-03-01";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "unparam";
    rev = "0df0534333a487d07b143c1b2c2e0046671d2d63";
    hash = "sha256-k/BgHvjB3fXz4CWTHRFja/EiGlof/c80jhRb91FaINs=";
  };

  vendorHash = "sha256-Q7q0NZgofxChaSpYL5dS4NDadwfrXlLtkG/F7tGJuhA=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Find unused parameters in Go";
    homepage = "https://github.com/mvdan/unparam";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "unparam";
  };
}
