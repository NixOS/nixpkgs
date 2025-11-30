{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gi-docgen,
  glib,
  json-glib,
  libsoup_3,
  libxml2,
  gobject-introspection,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "librest";
  version = "0.10.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/librest/${lib.versions.majorMinor version}/librest-${version}.tar.xz";
    sha256 = "e2y5Ers6Is+n3PAFkl3LYogwJNsMCQmUhufWhRGFybg=";
  };

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

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "librest";
      attrPath = "librest_1_0";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Helper library for RESTful services";
    homepage = "https://gitlab.gnome.org/GNOME/librest";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    teams = [ teams.gnome ];
  };
}
