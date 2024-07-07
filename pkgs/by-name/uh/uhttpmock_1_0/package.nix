{ stdenv
, lib
, fetchFromGitLab
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, gobject-introspection
, vala
, gtk-doc
, docbook-xsl-nons
, glib
, libsoup_3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uhttpmock";
  version = "0.10.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = "uhttpmock";
    rev = finalAttrs.version;
    hash = "sha256-d3IVlPOLOLzlUDuGOLll8pOK5FMsXI/d2wbwPZ6WI34=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  propagatedBuildInputs = [
    glib
    libsoup_3
  ];

  meta = with lib; {
    description = "Project for mocking web service APIs which use HTTP or HTTPS";
    homepage = "https://gitlab.freedesktop.org/pwithnall/uhttpmock/";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
