{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, gettext, vala
, python3, desktop-file-utils, libcanberra, gtk3, libgee, granite, libnotify
, libunity, pango, plank, bamf, sqlite, libdbusmenu-gtk3, zeitgeist, glib-networking
, elementary-icon-theme, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "files";
  version = "4.1.5";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0z0pisg7py2k6i31v18z5fgpj8x64m1s5clfq4vbbjrcjwx6dcx5";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib-networking
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    elementary-icon-theme
    granite
    gtk3
    libcanberra
    libdbusmenu-gtk3
    libgee
    libnotify
    libunity
    pango
    plank
    sqlite
    zeitgeist
  ];

  patches = [ ./hardcode-gsettings.patch ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace filechooser-module/FileChooserDialog.vala --subst-var-by ELEMENTARY_FILES_GSETTINGS_PATH $out/share/gsettings-schemas/${name}/glib-2.0/schemas
  '';

  # xdg.mime will create this
  postInstall = ''
    rm $out/share/applications/mimeinfo.cache
  '';

  meta = with stdenv.lib; {
    description = "File browser designed for elementary OS";
    homepage = https://github.com/elementary/files;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
