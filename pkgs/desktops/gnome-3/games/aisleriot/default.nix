{ stdenv, fetchurl, pkgconfig, gnome3, intltool, itstool, gtk3
, wrapGAppsHook, librsvg, libxml2, desktop-file-utils
, guile_2_0, libcanberra-gtk3 }:

stdenv.mkDerivation rec {
  pname = "aisleriot";
  version = "3.22.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "15pm39679ymxki07sb5nvhycz4z53zwbvascyp5wm4864bn98815";
  };

  configureFlags = [
    "--with-card-theme-formats=svg"
    "--with-platform=gtk-only" # until they remove GConf
  ];

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook libxml2 desktop-file-utils ];
  buildInputs = [ gtk3 librsvg guile_2_0 libcanberra-gtk3 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Aisleriot;
    description = "A collection of patience games written in guile scheme";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
