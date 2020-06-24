{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "public-sans";
  version = "1.008";

  src = fetchzip {
    url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";
    sha256 = "0cxx65hdz9q795ypr708p44a2p4y0nf6x1y138zpj29vll0cgmp5";
    stripRoot = false;
  };

  meta = with lib; {
    description = "A strong, neutral, principles-driven, open source typeface for text or display";
    homepage = "https://public-sans.digital.gov/";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
