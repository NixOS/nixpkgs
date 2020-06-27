{ mkFont, fetchzip }:

mkFont rec {
  pname = "MPH-2B-Damase";
  version = "2";

  src = fetchzip {
    url = "http://www.wazu.jp/downloads/damase_v.${version}.zip";
    sha256 = "1xf61w6vhy5qbhnn45s77fxyryn66blf641lhmgiqr1pww7zq7p3";
  };

  meta = {
  };
}
