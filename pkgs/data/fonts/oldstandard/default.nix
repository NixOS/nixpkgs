{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "oldstandard";
  version = "2.2";

  src = fetchzip {
    url = "https://github.com/akryukov/oldstand/releases/download/v${version}/${pname}-${version}.otf.zip";
    sha256 = "1hl78jw5szdjq9dhbcv2ln75wpp2lzcxrnfc36z35v5wk4l7jc3h";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://github.com/akryukov/oldstand";
    description = "An attempt to revive a specific type of Modern style of serif typefaces";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
