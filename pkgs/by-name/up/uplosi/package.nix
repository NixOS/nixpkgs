{ lib
, fetchFromGitHub
, buildGo121Module
}:
buildGo121Module rec {
  pname = "uplosi";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "edgelesssys";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YhB0kx/rbHMHSPC2zWcBY7bD677btSCyPEgWY7yuxC4=";
  };

  vendorHash = "sha256-3WLDmw2rhmjrKJ8QXtARS9p8qFx17iwUnljwoUep2uc=";

  CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" "-buildid=" "-X main.version=${version}" ];
  flags = [ "-trimpath" ];

  meta = with lib; {
    description = "Upload OS images to cloud provider";
    homepage = "https://github.com/edgelesssys/uplosi";
    changelog = "https://github.com/edgelesssys/uplosi/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "uplosi";
    maintainers = with maintainers; [ katexochen malt3 ];
    platforms = platforms.unix;
  };
}
