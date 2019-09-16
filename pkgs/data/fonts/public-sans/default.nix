{ lib, fetchzip }:

let
  version = "1.005";
in fetchzip {
  name = "public-sans-${version}";

  url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share
    unzip $downloadedFile fonts/{otf,variable}/\*.\[ot\]tf -d $out/share/
  '';

  sha256 = "0s0zgszpi12wanl031gi3j24ci9pkbkhvsxc30skx8s1mj99cd7i";

  meta = with lib; {
    description = "A strong, neutral, principles-driven, open source typeface for text or display";
    homepage = https://public-sans.digital.gov/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
