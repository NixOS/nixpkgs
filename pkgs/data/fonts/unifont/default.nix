{ lib, stdenv, fetchurl, mkfontscale
, libfaketime, fonttosfnt
}:

stdenv.mkDerivation rec {
  pname = "unifont";
  version = "14.0.02";

  ttf = fetchurl {
    # Unfortunately the 14.0.02 TTF file is not available on the GNU mirror.
    # Restore this for next version: "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.ttf";
    url = "https://unifoundry.com/pub/unifont/${pname}-${version}/font-builds/${pname}-${version}.ttf";
    sha256 = "1c8rdk3xg6j8lrzxddd73jppfgpk253jdkch63rr7n2d7ljp9gc3";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.pcf.gz";
    sha256 = "0hcl1zihm91xwvh5ds01sybgs0j8zsrrhn4wlz5j6ji99rh797jr";
  };

  nativeBuildInputs = [ libfaketime fonttosfnt mkfontscale ];

  dontUnpack = true;

  buildPhase =
    ''
      # convert pcf font to otb
      faketime -f "1970-01-01 00:00:01" \
      fonttosfnt -g 2 -m 2 -v -o "unifont.otb" "${pcf}"
    '';

  installPhase =
    ''
      # install otb fonts
      install -m 644 -D unifont.otb "$out/share/fonts/unifont.otb"
      mkfontdir "$out/share/fonts"

      # install pcf and ttf fonts
      install -m 644 -D ${pcf} $out/share/fonts/unifont.pcf.gz
      install -m 644 -D ${ttf} $out/share/fonts/truetype/unifont.ttf
      cd "$out/share/fonts"
      mkfontdir
      mkfontscale
    '';

  meta = with lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = "https://unifoundry.com/unifont/";

    # Basically GPL2+ with font exception.
    license = "https://unifoundry.com/LICENSE.txt";
    maintainers = [ maintainers.rycee maintainers.vrthra ];
    platforms = platforms.all;
  };
}
