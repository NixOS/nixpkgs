{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, libxml2
, glib
, gtk3
, gettext
, libsoup
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, gobject-introspection
, python3
, tzdata
, geocode-glib
, vala
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libgweather";
  version = "40.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1rkf4yv43qcahyx7bismdv6z2vh5azdnm1fqfmnzrada9cm8ykna";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    vala
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
    python3
    python3.pkgs.pygobject3
  ];

  buildInputs = [
    glib
    gtk3
    libsoup
    libxml2
    geocode-glib
  ];

  mesonFlags = [
    "-Dzoneinfo_dir=${tzdata}/share/zoneinfo"
    "-Denable_vala=true"
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    chmod +x meson/meson_post_install.py
    patchShebangs meson/meson_post_install.py
    patchShebangs data/gen_locations_variant.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A library to access weather information from online services for numerous locations";
    homepage = "https://wiki.gnome.org/Projects/LibGWeather";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
