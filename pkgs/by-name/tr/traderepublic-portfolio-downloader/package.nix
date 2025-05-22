{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "traderepublic-portfolio-downloader";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "dhojayev";
    repo = "traderepublic-portfolio-downloader";
    tag = "v${version}";
    hash = "sha256-z+8VIN3rN1s8VFIGIJ6mwKbcajIcfN0TnB0Vfq5VXYM=";
  };

  vendorHash = "sha256-MapulF+ppRW3ClI9RlVV5TEp/nNQz3LD5WdwN5AL8sw=";

  postInstall = ''
    mv $out/bin/public $out/bin/traderepublic-portfolio-downloader
    rm $out/bin/dev
    rm $out/bin/example-generator
  '';

  meta = {
    description = "Downloads trade republic portfolio data";
    homepage = "https://github.com/dhojayev/traderepublic-portfolio-downloader";
    changelog = "https://github.com/dhojayev/traderepublic-portfolio-downloader/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    mainProgram = "traderepublic-portfolio-downloader";
    maintainers = with lib.maintainers; [ seineeloquenz ];
    platforms = lib.platforms.linux;
  };
}
