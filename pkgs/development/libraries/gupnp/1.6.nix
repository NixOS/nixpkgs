{ stdenv
, lib
, fetchpatch
, fetchurl
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
  version = "1.6.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-T09Biwe4EWTfH3q2EuKOTAFsLQhbik85+XlF+LFe4kg=";
  };

  patches = [
    (fetchpatch {
      # https://gitlab.gnome.org/GNOME/gupnp/-/merge_requests/32
      name = "gi-docgen-as-native-dep.patch";
      url = "https://gitlab.gnome.org/GNOME/gupnp/-/commit/11d4a33cff1f5d8b8ad4b80c4506246a9e0dff8f.diff";
      hash = "sha256-+p4vzUG2v+7mxtQ5AUcEI7SW0cDX6XlzqlyegF+I1Go=";
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
