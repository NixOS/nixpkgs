{ lib, stdenv, fetchurl, mkfontscale
, libfaketime, fonttosfnt
}:

stdenv.mkDerivation rec {
  pname = "unifont";
  version = "14.0.03";

  ttf = fetchurl {
    url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.ttf";
    sha256 = "1qyc7nqyhjnarwgpkah52qv7hr0yfzak7084ilrj7z0nii4f5y57";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${pname}-${version}/${pname}-${version}.pcf.gz";
    sha256 = "1sgvxpr4ydjnbk70j0lpgxz5x851lmrmxjb5x8lsz0i2hm32jdbc";
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
