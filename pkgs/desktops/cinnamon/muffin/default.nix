{ fetchFromGitHub
, cinnamon-desktop
, glib
, file
, gnome3
, gnome-doc-utils
, fetchpatch
, gobject-introspection
, gtk3
, intltool
, json-glib
, libinput
, libstartup_notification
, libXtst
, libxkbcommon
, pkgconfig
, stdenv
, udev
, xorg
, wrapGAppsHook
, pango
, cairo
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, docbook_xml_dtd_42
, docbook_xml_dtd_412
, autoconf
, automake
, gettext
, libtool
}:

# it's a frankensteins monster with some cinnamon sparkles added on top of it

stdenv.mkDerivation rec {
  pname = "muffin";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1kzjw4a5p69j8x55vpbpn6gy8pkbbyii6kzw2nzbypmipgnnijw8";
  };

  patches = [
    # backport patch that disables wayland components via build flags
    # https://github.com/linuxmint/muffin/pull/548#issuecomment-578316820
    (fetchpatch {
      url = "https://github.com/linuxmint/muffin/commit/f78bf5b309b3d306848f47cc241b31e9399999a7.patch";
      sha256 = "1c79aa9w2v23xlz86x3l42pavwrqx5d6nmfd9nms29hjsk8mpf4i";
    })
    # mute some warnings that caused build failures
    # https://github.com/linuxmint/muffin/issues/535#issuecomment-536917143
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/muffin/raw/6b0af3a22173e374804371a1cca74e23d696dd37/f/0001-fix-warnings-when-compiling.patch";
      sha256 = "15wdbn3afn3103v7rq1icp8n0vqqwrrya03h0g2rzqlrsc7wrvzw";
    })
  ];

  buildInputs = [
    gtk3
    glib
    pango
    cairo
    json-glib
    cinnamon-desktop
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libxkbfile
    xorg.xkeyboardconfig

    libxkbcommon
    gnome3.zenity
    libinput
    libstartup_notification
    libXtst
    udev
    gobject-introspection
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    wrapGAppsHook
    pkgconfig
    intltool

    gnome-doc-utils
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    docbook_xml_dtd_42
    docbook_xml_dtd_412
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/muffin";
    description = "The window management library for the Cinnamon desktop (libmuffin) and its sample WM binary (muffin)";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
