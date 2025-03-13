{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "traderepublic-portfolio-downloader";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "dhojayev";
    repo = "traderepublic-portfolio-downloader";
    tag = "v${version}";
    hash = "sha256-U3cyQ449e7whFE5DnOlYL6qdOQgkpLPnd5ZxAG+WkRc=";
  };

  vendorHash = "sha256-VzBBY1mNbT6qHnsy1GE+jWXHZcUo3TNefQixVFF+HYA=";

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
