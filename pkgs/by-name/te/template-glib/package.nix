{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gi-docgen,
  glib,
  gobject-introspection,
  flex,
  bison,
  vala,
  gettext,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "template-glib";
  version = "3.38.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/template-glib/${lib.versions.majorMinor finalAttrs.version}/template-glib-${finalAttrs.version}.tar.xz";
    hash = "sha256-QNANwiPc8ut/LsQi997FpnNzoMoRAavKD0nGLwUMsxI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    flex
    bison
    vala
    gi-docgen
    glib
    gobject-introspection
  ];

  buildInputs = [
    glib
  ];

  mesonFlags = [
    "-Ddocs=true"
  ];

  doCheck = true;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput share/doc/template-glib-1.0 "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "template-glib";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Library for template expansion which supports calling into GObject Introspection from templates";
    homepage = "https://gitlab.gnome.org/GNOME/template-glib";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
})
