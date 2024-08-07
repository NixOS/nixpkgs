{
  stdenv,
  lib,
  fetchurl,
  docbook-xsl-nons,
  glib,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  icu,
  enchant2,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gspell";
  version = "1.13.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "zO1F6Ykro1wxuaEdYqnhVC5d/Wj3+zfDNbp0SfIM1hU=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gspell/-/merge_requests/10
    ./0001-Darwin-build-fix.patch
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    glib # glib-mkenums
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
    icu
  ];

  propagatedBuildInputs = [
    # required for pkg-config
    enchant2
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Spell-checking library for GTK applications";
    mainProgram = "gspell-app1";
    homepage = "https://gitlab.gnome.org/GNOME/gspell";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
