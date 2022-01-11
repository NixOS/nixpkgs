{ lib, stdenv, fetchurl, pkg-config, gettext, mate-icon-theme, gtk2, gtk3,
  gtk_engines, gtk-engine-murrine, gdk-pixbuf, librsvg, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-themes";
  version = "3.22.23";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/themes/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1avgzccdmr7y18rnp3xrhwk82alv2dlig3wh7ivgahcqdiiavrb1";
  };

  nativeBuildInputs = [ pkg-config gettext gtk3 ];

  buildInputs = [ mate-icon-theme gtk2 gtk_engines gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/ContrastHigh
  '';

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript {
    inherit pname version;
    url = "https://pub.mate-desktop.org/releases/themes";
  };

  meta = with lib; {
    description = "A set of themes from MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ lgpl21Plus lgpl3Only gpl3Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
