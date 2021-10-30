{ lib, stdenv, fetchurl, pkg-config, gtk3, intltool
, gnome, enchant, isocodes, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gtkhtml";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "ca3b6424fb2c7ac5d9cb8fdafb69318fa2e825c9cf6ed17d1e38d9b29e5606c3";
  };

  passthru = {
    updateScript = gnome.updateScript { packageName = "gtkhtml"; attrPath = "gnome.gtkhtml"; };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 intltool gnome.adwaita-icon-theme
                  gsettings-desktop-schemas ];

  propagatedBuildInputs = [ enchant isocodes ];

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
