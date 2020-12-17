{ stdenv, gettext, libxml2, libhandy, fetchurl, pkgconfig, libcanberra-gtk3
, gtk3, glib, meson, ninja, python3, wrapGAppsHook, appstream-glib, desktop-file-utils
, gnome3, gsettings-desktop-schemas }:

let
  pname = "gnome-screenshot";
  version = "3.38.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1h4zsaybjrlkfcrvriyybg4gfr7v9d1ndh2p516k94ad2gfx6mp5";
  };

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/postinstall.py # patchShebangs requires executable file
    patchShebangs build-aux/postinstall.py
  '';

  nativeBuildInputs = [ meson ninja pkgconfig gettext appstream-glib libxml2 desktop-file-utils python3 wrapGAppsHook ];
  buildInputs = [
    gtk3 glib libcanberra-gtk3 libhandy gnome3.adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://en.wikipedia.org/wiki/GNOME_Screenshot";
    description = "Utility used in the GNOME desktop environment for taking screenshots";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
