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

stdenv.mkDerivation (finalAttrs: {
  pname = "gupnp";
  version = "1.6.9";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${lib.versions.majorMinor finalAttrs.version}/gupnp-${finalAttrs.version}.tar.xz";
    hash = "sha256-Lttu42E1WOYvU4c1NoruJxUbfgnU4uLFFgaDPagBhps=";
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

  # On Darwin: Failed to bind socket, Operation not permitted
  doCheck = !stdenv.hostPlatform.isDarwin;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gupnp_1_6";
      packageName = "gupnp";
    };
  };

  meta = with lib; {
    homepage = "http://www.gupnp.org/";
    description = "Implementation of the UPnP specification";
    mainProgram = "gupnp-binding-tool-1.6";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
})
