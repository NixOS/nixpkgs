{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  pango,
  glibmm,
  cairomm,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "pangomm";
  version = "2.46.4";

  src = fetchurl {
    url = "mirror://gnome/sources/pangomm/${lib.versions.majorMinor version}/pangomm-${version}.tar.xz";
    sha256 = "sha256-uSAWZhUmQk3kuTd/FRL1l4H0H7FsnAJn1hM7oc1o2yI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];
  propagatedBuildInputs = [
    pango
    glibmm
    cairomm
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "pangomm";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "C++ interface to the Pango text rendering library";
    homepage = "https://www.pango.org/";
    license = with licenses; [
      lgpl2
      lgpl21
    ];
    maintainers = with maintainers; [
      lovek323
      raskin
    ];
    platforms = platforms.unix;

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';
  };
}
