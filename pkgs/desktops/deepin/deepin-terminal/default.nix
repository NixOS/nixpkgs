{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, cmake, ninja, vala,
  gettext, gobject-introspection, at-spi2-core, dbus, epoxy, expect,
  gtk3, json-glib, libXdmcp, libgee, libpthreadstubs, librsvg,
  libsecret, libtasn1, libxcb, libxkbcommon, p11-kit, pcre, vte, wnck,
  libselinux, libsepol, utillinux, deepin-menu,
  deepin-shortcut-viewer, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-terminal";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "17a7w6sifwnqzkj85bc9v0qczkl9jjzydg33xg1jdd9va4x08z4g";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
    ninja
    vala
    gettext
    gobject-introspection # For setup hook
    libselinux libsepol utillinux # required by gio
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

  cmakeFlags = [
    "-DTEST_BUILD=OFF"
    "-DUSE_VENDOR_LIB=OFF"
    "-DVERSION=${version}"
  ];

  postInstall = ''
    ln -s deepin-terminal "$out"/bin/x-terminal-emulator
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Default terminal emulator for Deepin";
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
