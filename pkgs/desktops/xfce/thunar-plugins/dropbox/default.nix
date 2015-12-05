{ stdenv, fetchurl, pkgconfig
, gtk
, thunarx-2-dev, python2
}:

stdenv.mkDerivation rec {
  p_name  = "thunar-dropbox-plugin";
  ver_maj = "0.2";
  ver_min = "1";
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "http://softwarebakery.com/maato/files/thunar-dropbox/thunar-dropbox-${ver_maj}.${ver_min}.tar.bz2";
    sha256 = "08vhzzzwshyz371yl7fzfylmhvchhv3s5kml3dva4v39jhvrpnkf";
  };

  buildInputs = [
    pkgconfig
    gtk
    thunarx-2-dev python2
  ];

  configurePhase = "python2 waf configure --prefix=$out";

  buildPhase = "python2 waf";

  installPhase = ''
    python2 waf install
  '';

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://softwarebakery.com/maato/thunar-dropbox.html;
    description = "A plugin for thunar that adds context-menu items from dropbox";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
