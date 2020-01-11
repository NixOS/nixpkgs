{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, gettext, meson, gsound, librsvg, itstool, vala
, python3, ninja, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "four-in-a-row";
  version = "3.34.1";

  src = fetchurl {
    url = "mirror://gnome/sources/four-in-a-row/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "112pyrh2yvwy5b2a0b5crjpwp2vqqg4zgx6csll1bic6ccayv713";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook gettext meson itstool vala
    ninja python3 desktop-file-utils
  ];
  buildInputs = [ gtk3 gsound librsvg gnome3.adwaita-icon-theme ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "four-in-a-row";
      attrPath = "gnome3.four-in-a-row";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Four-in-a-row;
    description = "Make lines of the same color to win";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
