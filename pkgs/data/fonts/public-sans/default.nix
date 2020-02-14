{ lib, fetchzip }:

let
  version = "1.008";
in fetchzip {
  name = "public-sans-${version}";

  url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile binaries/otf/\*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile binaries/variable/\*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile binaries/webfonts/\*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile binaries/webfonts/\*.woff -d $out/share/fonts/woff
    unzip -j $downloadedFile binaries/webfonts/\*.woff2 -d $out/share/fonts/woff2
  '';

  sha256 = "1s4xmliri3r1gcn1ws3wa6davj6giliqjdbcv0bh9ryg3dfpjz74";

  meta = with lib; {
    description = "A strong, neutral, principles-driven, open source typeface for text or display";
    homepage = https://public-sans.digital.gov/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
