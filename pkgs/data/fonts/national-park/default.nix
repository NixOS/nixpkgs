{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "national-park-typeface";
  version = "206464";

  src = fetchzip {
    url = "https://files.cargocollective.com/c${version}/NationalPark.zip";
    sha256 = "03lzlyjnjn8mhbqm1bxb55i09lbsf5sa7mw1kslsnz29jmjyhijm";
    stripRoot = false;
  };

  meta = with lib; {
    description = ''Typeface designed to mimic the national park service
    signs that are carved using a router bit'';
    homepage = "https://nationalparktypeface.com/";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
  };
}
