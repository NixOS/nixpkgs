{
  lib,
  stdenv,
  fetchurl,
  xorg,
  libfaketime,
}:

stdenv.mkDerivation rec {
  pname = "unifont";
  version = "16.0.02";

  otf = fetchurl {
    url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.otf";
    hash = "sha256-3oI6EOZeIkOt56mK+CuC68a71c89CqPjjtTMzTa8qzM=";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.pcf.gz";
    hash = "sha256-AqP+EZlNPNrx1L1dK2tglzXmgj4BdkroO3BOAuwvZA0=";
  };

  nativeBuildInputs = [
    libfaketime
    xorg.fonttosfnt
    xorg.mkfontscale
  ];

  dontUnpack = true;

  buildPhase = ''
    # convert pcf font to otb
    faketime -f "1970-01-01 00:00:01" \
    fonttosfnt -g 2 -m 2 -v -o "unifont.otb" "${pcf}"
  '';

  installPhase = ''
    # install otb fonts
    install -m 644 -D unifont.otb "$out/share/fonts/unifont.otb"
    mkfontdir "$out/share/fonts"

    # install pcf and otf fonts
    install -m 644 -D ${pcf} $out/share/fonts/unifont.pcf.gz
    install -m 644 -D ${otf} $out/share/fonts/opentype/unifont.otf
    cd "$out/share/fonts"
    mkfontdir
    mkfontscale
  '';

  meta = with lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = "https://unifoundry.com/unifont/";

    # Basically GPL2+ with font exception.
    license = "https://unifoundry.com/LICENSE.txt";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
