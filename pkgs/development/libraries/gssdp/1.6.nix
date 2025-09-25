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
  python3,
  libsoup_3,
  glib,
  gnome,
  gssdp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gssdp";
  version = "1.6.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor finalAttrs.version}/gssdp-${finalAttrs.version}.tar.xz";
    hash = "sha256-/5f9+39WHT5oE7T2ohRSWefC7/Q8wOY/P9Ax0LYmYDI=";
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
    python3
  ];

  buildInputs = [
    libsoup_3
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dsniffer=false"
    # This packages only has manpages for gssdp-device-sniffer, which we disabled above.
    "-Dmanpages=false"
  ];

  # On Darwin: Failed to bind socket, Operation not permitted
  doCheck = !stdenv.hostPlatform.isDarwin;

  postFixup = ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
      | while IFS= read -r -d ''' file; do
        moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gssdp_1_6";
      packageName = "gssdp";
    };

    tests = {
      inherit gssdp-tools;
    };
  };

  meta = with lib; {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.all;
  };
})
