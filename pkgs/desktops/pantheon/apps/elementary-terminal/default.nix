{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, python3
, vala, desktop-file-utils, gtk3, libxml2, granite, libnotify, vte, libgee
, elementary-icon-theme, appstream, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "terminal";
  version = "5.3.5";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1gd5m24digmx3sgs21ggfiqiwhgym6s1dlg1sv9mdqh5wgsa6b8f";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gobject-introspection
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    granite
    gtk3
    libgee
    libnotify
    vte
  ];

  # See https://github.com/elementary/terminal/commit/914d4b0e2d0a137f12276d748ae07072b95eff80
  mesonFlags = [ "-Dubuntu-bionic-patched-vte=false" ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Terminal emulator designed for elementary OS";
    longDescription = ''
      A super lightweight, beautiful, and simple terminal. Comes with sane defaults, browser-class tabs, sudo paste protection,
      smart copy/paste, and little to no configuration.
    '';
    homepage = https://github.com/elementary/terminal;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
