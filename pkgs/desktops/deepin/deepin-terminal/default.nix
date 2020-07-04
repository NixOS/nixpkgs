{ stdenv
, fetchFromGitHub
, pkgconfig
, cmake
, ninja
, vala_0_40
, fetchpatch
, gettext
, at-spi2-core
, dbus
, epoxy
, expect
, gtk3
, json-glib
, libXdmcp
, libgee
, libpthreadstubs
, librsvg
, libsecret
, libtasn1
, libxcb
, libxkbcommon
, p11-kit
, pcre
, vte
, wnck
, libselinux
, gnutls
, pcre2
, libsepol
, utillinux
, deepin-menu
, deepin-shortcut-viewer
, deepin
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "deepin-terminal";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "1929saj828b438d07caw3cjhqq60v6gni7mi3fqrg9wdjz81xwv7";
  };

  patches = [
    # Fix build with VTE 0.60
    (fetchpatch {
      url = "https://github.com/linuxdeepin/deepin-terminal/commit/542d1035b609698ee81aa7971d20ca8e5930743d.patch";
      sha256 = "1pihiy70yc25fm5fx7i7v9gmi65v4mhldvi7xwv8rgr2z6hbfj41";
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    cmake
    ninja
    vala_0_40 # xcb.vapi:411.3-411.48: error: missing return statement at end of subroutine body
    gettext
    libselinux libsepol utillinux # required by gio
    deepin.setupHook
    wrapGAppsHook
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
    gnutls
    pcre2
  ];

  postPatch = ''
    searchHardCodedPaths
  '';

  cmakeFlags = [
    "-DTEST_BUILD=OFF"
    "-DUSE_VENDOR_LIB=OFF"
    "-DVERSION=${version}"
  ];

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Default terminal emulator for Deepin";
    longDescription = ''
      Deepin terminal, it sharpens your focus in the world of command line!
      It is an advanced terminal emulator with workspace, multiple
      windows, remote management, quake mode and other features.
    '';
    homepage = "https://github.com/linuxdeepin/deepin-terminal";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
