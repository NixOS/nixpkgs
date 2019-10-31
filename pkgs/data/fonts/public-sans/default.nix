{ lib, fetchzip }:

let
  version = "1.006";
in fetchzip {
  name = "public-sans-${version}";

  url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share
    unzip $downloadedFile fonts/{otf,variable}/\*.\[ot\]tf -d $out/share/
  '';

  sha256 = "1x04mpynfhcgiwx68w5sawgn69xld7k65mbq7n5vcgbfzh2sjwhq";

  meta = with lib; {
    description = "A strong, neutral, principles-driven, open source typeface for text or display";
    homepage = https://public-sans.digital.gov/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
