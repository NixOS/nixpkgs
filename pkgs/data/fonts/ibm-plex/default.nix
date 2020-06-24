{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "ibm-plex";
  version = "5.0.0";

  src = fetchzip {
    url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";
    sha256 = "0bp4xlg7w2kvivn8sr2dfclfdm8xgdhgc7nx2lfahllx5zj1rjyg";
  };

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
