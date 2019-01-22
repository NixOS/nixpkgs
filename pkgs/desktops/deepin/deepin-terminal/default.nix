{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, cmake, ninja, vala,
  gettext, gobject-introspection, at-spi2-core, dbus, epoxy, expect,
  gtk3, json-glib, libXdmcp, libgee, libpthreadstubs, librsvg,
  libsecret, libtasn1, libxcb, libxkbcommon, p11-kit, pcre, vte, wnck,
  deepin-menu, deepin-shortcut-viewer, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-terminal";
  version = "3.0.10.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "0ylhp8q9kfdq9l69drawjaf0q8vcqyflb2a3zfnwbnf06dlpvkz6";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
    ninja
    vala
    gettext
    gobject-introspection # For setup hook
  ];

  buildInputs = [
    at-spi2-core
    dbus
    deepin-menu
    deepin-shortcut-viewer
    epoxy
    expect
    gtk3
    json-glib
    libXdmcp
    libgee
    libpthreadstubs
    librsvg
    libsecret
    libtasn1
    libxcb
    libxkbcommon
    p11-kit
    pcre
    vte
    wnck
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "The default terminal emulation for Deepin";
    longDescription = ''
      Deepin terminal, it sharpens your focus in the world of command line!
      It is an advanced terminal emulator with workspace, multiple
      windows, remote management, quake mode and other features.
     '';
    homepage = https://github.com/linuxdeepin/deepin-terminal;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
