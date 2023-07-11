{ lib
, stdenv
, fetchpatch
, fetchurl
, meson
, ninja
, pkg-config
, gi-docgen
, glib
, json-glib
, libsoup_3
, libxml2
, gobject-introspection
, gnome
}:

stdenv.mkDerivation rec {
  pname = "rest";
  version = "0.9.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "kmalwQ7OOD4ZPft/+we1CcwfUVIauNrXavlu0UISwuM=";
  };

  patches = [
    # Pick up MR 30 (https://gitlab.gnome.org/GNOME/librest/-/merge_requests/30) to fix GOA crashes with libsoup 3
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/librest/-/commit/fbad64abe28a96f591a30e3a5d3189c10172a414.patch";
      hash = "sha256-r8+h84Y/AdM1IOMRcBVwDvfqapqOY8ZtRXdOIQvFR9w=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/librest/-/commit/8049048a0f7d52b3f4101c7123797fed099d4cc8.patch";
      hash = "sha256-AMhHKzzOoTIlkRwN4KfUwdhxlqvtRgiVjKRfnG7KZwc=";
    })
  ];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
  ];

  propagatedBuildInputs = [
    glib
    json-glib
    libsoup_3
    libxml2
  ];

  mesonFlags = [
    "-Dexamples=false"

    # Remove when https://gitlab.gnome.org/GNOME/librest/merge_requests/2 is merged.
    "-Dca_certificates=true"
    "-Dca_certificates_path=/etc/ssl/certs/ca-certificates.crt"
  ];

  postPatch = ''
    # https://gitlab.gnome.org/GNOME/librest/-/merge_requests/19
    substituteInPlace meson.build \
      --replace "con." "conf."

    # Run-time dependency gi-docgen found: NO (tried pkgconfig and cmake)
    # it should be a build-time dep for build
    # TODO: send upstream
    substituteInPlace docs/meson.build \
      --replace "'gi-docgen', ver" "'gi-docgen', native:true, ver"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "librest_1_0";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Helper library for RESTful services";
    homepage = "https://wiki.gnome.org/Projects/Librest";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
