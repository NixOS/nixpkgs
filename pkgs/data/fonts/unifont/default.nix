{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "10.0.04";

  ttf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.ttf";
    sha256 = "0qp9zf8cx86syr8wl2z8yxlr5r83n156744ylzc0cg3rlmkx6r22";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.pcf.gz";
    sha256 = "1mj2np6j4jdbfnl0i3zlpg95ic9zq8bhvz8wf3pxkc85zmnk6w62";
  };

  buildInputs = [ mkfontscale mkfontdir ];

  phases = "installPhase";

  installPhase =
    ''
      mkdir -p $out/share/fonts $out/share/fonts/truetype
      cp -v ${pcf} $out/share/fonts/unifont.pcf.gz
      cp -v ${ttf} $out/share/fonts/truetype/unifont.ttf
      cd $out/share/fonts
      mkfontdir
      mkfontscale
    '';

  meta = with stdenv.lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.rycee maintainers.vrthra ];
    platforms = platforms.all;
  };
}
