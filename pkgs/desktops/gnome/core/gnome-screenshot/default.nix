{ lib, stdenv, gettext, libxml2, libhandy, fetchurl, pkg-config, libcanberra-gtk3
, gtk3, glib, meson, ninja, python3, wrapGAppsHook, appstream-glib, desktop-file-utils
, gnome, gsettings-desktop-schemas }:

let
  pname = "gnome-screenshot";
  version = "40.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${name}.tar.xz";
    sha256 = "1qm544ymwibk31s30k47vnn79xg30m18r7l4di0c57g375dak31n";
  };

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/postinstall.py # patchShebangs requires executable file
    patchShebangs build-aux/postinstall.py
  '';

  nativeBuildInputs = [ meson ninja pkg-config gettext appstream-glib libxml2 desktop-file-utils python3 wrapGAppsHook ];
  buildInputs = [
    gtk3 glib libcanberra-gtk3 libhandy gnome.adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://en.wikipedia.org/wiki/GNOME_Screenshot";
    description = "Utility used in the GNOME desktop environment for taking screenshots";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
