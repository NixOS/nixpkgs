{ lib, mkFont, fetchurl, mkfontscale , libfaketime, fonttosfnt }:

mkFont rec {
  pname = "unifont";
  version = "13.0.01";

  srcs = map fetchurl [
    {
      url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.ttf";
      sha256 = "0y5bd7i5hp9ks6d3qq0bshywba7g90i3074wckpn9m8shh98ngcg";
    }
    {
      url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.pcf.gz";
      sha256 = "05zgz00n514cijqh9qcvr4iz0bla4hd028cvi1jlh0ic6fkafix8";
    }
  ];

  nativeBuildInputs = [ libfaketime fonttosfnt mkfontscale ];
  noUnpackFonts = true;

  dontBuild = false;
  buildPhase = ''
    # convert pcf font to otb
    faketime -f "1970-01-01 00:00:01" fonttosfnt -g 2 -m 2 -v -o "unifont.otb" unifont-${version}.pcf.gz
  '';

  meta = with lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = "http://unifoundry.com/unifont.html";

    # Basically GPL2+ with font exception.
    license = "http://unifoundry.com/LICENSE.txt";
    platforms = platforms.all;
    maintainers = with maintainers; [ rycee vrthra ];
  };
}
