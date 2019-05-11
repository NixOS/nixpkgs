{ stdenv, fetchzip }:

let
  version = "1.003";
in fetchzip rec {
  name = "public-sans-${version}";

  url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share
    unzip $downloadedFile fonts/{otf,variable}/\*.\[ot\]tf -d $out/share/
  '';

  sha256 = "02ranwr1bw4n9n1ljw234nzhj2a0hgradniib37nh10maark5wg3";

  meta = with stdenv.lib; {
    description = "A strong, neutral, principles-driven, open source typeface for text or display";
    homepage = https://public-sans.digital.gov/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
