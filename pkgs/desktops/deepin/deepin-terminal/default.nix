{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, cmake, ninja, vala,
  gettext, at-spi2-core, dbus, epoxy, expect, gtk3, json-glib,
  libXdmcp, libgee, libpthreadstubs, librsvg, libsecret, libtasn1,
  libxcb, libxkbcommon, p11-kit, pcre, vte, wnck, libselinux,
  libsepol, utillinux, deepin-menu, deepin-shortcut-viewer, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-terminal";
  version = "3.2.2.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "08bhdd9q4aqy5yjbpqy918j63c3b2rrdqdkxh3fk258n1fm72gmw";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
    ninja
    vala
    gettext
    libselinux libsepol utillinux # required by gio
    deepin.setupHook
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
    searchHardCodedPaths
  '';

  cmakeFlags = [
    "-DTEST_BUILD=OFF"
    "-DUSE_VENDOR_LIB=OFF"
    "-DVERSION=${version}"
  ];

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
