{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "uplosi";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "edgelesssys";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9hOeKnjH6r3CPQSe6fQ6PXlVPEJ9NiyXvp5N1krG2XA=";
  };

  vendorHash = "sha256-RsjUPLe8omoN+XGyNhHDxzNfZR7VVTkh/f/On1oCRqM=";

  CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" "-X main.version=${version}" ];
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
