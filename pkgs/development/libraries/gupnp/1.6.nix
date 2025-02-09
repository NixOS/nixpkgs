{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
  gssdp_1_6,
  libsoup_3,
  libxml2,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gupnp";
  version = "1.6.8";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-cKADzr1oV3KT+z5q9J/5AiA7+HaLL8XWUd3B8PoeEek=";
  };

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
    description = "Implementation of the UPnP specification";
    mainProgram = "gupnp-binding-tool-1.6";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
