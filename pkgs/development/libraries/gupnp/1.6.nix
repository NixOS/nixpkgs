{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, gi-docgen
, glib
, gssdp_1_6
, libsoup_3
, libxml2
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gupnp";
  version = "1.5.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-dF4/qzOzqhbbNCYxmK/c/9XjWCKjKA277O9210HEhoc=";
  };

  patches = [
    # Do not use deprecated symbols after libsoup update.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gupnp/-/commit/1296d10eda308792d2924f141d72b8b6818878bd.patch";
      sha256 = "mboJQ9I7oV+HXt0atUSLt6FDTCCT22lbuI7OUb0tDLM=";
    })

    # Fix test after libsoup update.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gupnp/-/commit/fba0ca75445189f6554bd66fb3aa4f022b8f69e9.patch";
      sha256 = "6dkpnDqHVvesrzEIYLbHdoB0dfePr0ll8jQxijuu24E=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
  ];

  propagatedBuildInputs = [
    glib
    gssdp_1_6
    libsoup_3
    libxml2
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dintrospection=true"
  ];

  doCheck = true;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gupnp_1_6";
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "http://www.gupnp.org/";
    description = "An implementation of the UPnP specification";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
