{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "hermit";
  version = "2.0";

  src = fetchzip {
    url = "https://pcaro.es/d/otf-${pname}-${version}.tar.gz";
    sha256 = "0r2r692332x34mlgcc74dmc6fhw3zdy8ac71h5n8q13w4bdxk1a5";
    stripRoot = false;
  };

  meta = with lib; {
    description = "monospace font designed to be clear, pragmatic and very readable";
    homepage = "https://pcaro.es/p/hermit";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

