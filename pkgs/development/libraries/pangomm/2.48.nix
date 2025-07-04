{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  pango,
  glibmm_2_68,
  cairomm_1_16,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "pangomm";
  version = "2.56.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/pangomm/${lib.versions.majorMinor version}/pangomm-${version}.tar.xz";
    hash = "sha256-U59apg6b3GuVW7RI4qYswUVidE32kCWAQPu3S/iFdV0=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];

  propagatedBuildInputs = [
    pango
    glibmm_2_68
    cairomm_1_16
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "pangomm";
      attrPath = "pangomm_2_48";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "C++ interface to the Pango text rendering library";
    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';
    homepage = "https://www.pango.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      lovek323
      raskin
    ];
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
}
