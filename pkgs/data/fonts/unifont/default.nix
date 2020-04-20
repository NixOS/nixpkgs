{ stdenv, fetchurl, mkfontscale
, libfaketime, fonttosfnt
}:

stdenv.mkDerivation rec {
  pname = "unifont";
  version = "13.0.01";

  ttf = fetchurl {
    url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.ttf";
    sha256 = "0y5bd7i5hp9ks6d3qq0bshywba7g90i3074wckpn9m8shh98ngcg";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.pcf.gz";
    sha256 = "05zgz00n514cijqh9qcvr4iz0bla4hd028cvi1jlh0ic6fkafix8";
  };

  nativeBuildInputs = [ libfaketime fonttosfnt mkfontscale ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase =
    ''
      # convert pcf font to otb
      faketime -f "1970-01-01 00:00:01" \
      fonttosfnt -g 2 -m 2 -v -o "unifont.otb" "${pcf}"
    '';

  installPhase =
    ''
      # install otb fonts
      install -m 644 -D unifont.otb "$otb/share/fonts/unifont.otb"
      mkfontdir "$otb/share/fonts"

      # install pcf and ttf fonts
      install -m 644 -D ${pcf} $out/share/fonts/unifont.pcf.gz
      install -m 644 -D ${ttf} $out/share/fonts/truetype/unifont.ttf
      cd "$out/share/fonts"
      mkfontdir
      mkfontscale
    '';

  outputs = [ "out" "otb" ];

  meta = with stdenv.lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = "http://unifoundry.com/unifont.html";

    # Basically GPL2+ with font exception.
    license = "http://unifoundry.com/LICENSE.txt";
    maintainers = [ maintainers.rycee maintainers.vrthra ];
    platforms = platforms.all;
  };
}
