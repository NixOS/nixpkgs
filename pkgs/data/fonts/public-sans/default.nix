{ lib, fetchzip }:

let
  version = "1.004";
in fetchzip rec {
  name = "public-sans-${version}";

  url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share
    unzip $downloadedFile fonts/{otf,variable}/\*.\[ot\]tf -d $out/share/
  '';

  sha256 = "1d9ll6gvvlmlykv868lq7xmwldlfjp94k0rjqifipg3q1qv051lg";

  meta = with lib; {
    description = "A strong, neutral, principles-driven, open source typeface for text or display";
    homepage = https://public-sans.digital.gov/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
