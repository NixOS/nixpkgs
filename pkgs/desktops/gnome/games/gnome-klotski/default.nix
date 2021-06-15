{ lib, stdenv, fetchurl, pkg-config, vala, gnome, gtk3, wrapGAppsHook, appstream-glib, desktop-file-utils
, glib, librsvg, libxml2, gettext, itstool, libgee, libgnome-games-support
, meson, ninja, python3
}:

let
  pname = "gnome-klotski";
  version = "3.38.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1qm01hdd5yp8chig62bj10912vclbdvywwczs84sfg4zci2phqwi";
  };

  nativeBuildInputs = [
    pkg-config vala meson ninja python3 wrapGAppsHook
    gettext itstool libxml2 appstream-glib desktop-file-utils
    gnome.adwaita-icon-theme
  ];
  buildInputs = [ glib gtk3 librsvg libgee libgnome-games-support ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Klotski";
    description = "Slide blocks to solve the puzzle";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
