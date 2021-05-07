{ lib, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, gnome
, glib
, gtk3
, wrapGAppsHook
, gettext
, itstool
, libxml2
, libxslt
, docbook_xsl
, docbook_xml_dtd_43
, systemd
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-logs";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0w1nfdxbv3f0wnhmdy21ydvr4swfc108hypda561p7l9lrhnnxj4";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gnome-logs/-/issues/52
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-logs/-/commit/b42defceefc775220b525f665a3b662ab9593b81.patch";
      sha256 = "1s0zscmhwy7r0xff17wh8ik8x9xw1vrkipw5vl5i770bxnljps8n";
    })
  ];

  nativeBuildInputs = [
    python3
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gettext
    itstool
    libxml2
    libxslt
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
    gtk3
    systemd
    gsettings-desktop-schemas
    gnome.adwaita-icon-theme
  ];

  mesonFlags = [
    "-Dman=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-logs";
      attrPath = "gnome.gnome-logs";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Logs";
    description = "A log viewer for the systemd journal";
    maintainers = teams.gnome.members;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
