{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, SDL2
, alsaLib
, bullet
, check
, curl
, dbus
, doxygen
, expat
, fontconfig
, freetype
, fribidi
, ghostscript
, giflib
, glib
, gst_all_1
, gtk3
, harfbuzz
, hicolor-icon-theme
, ibus
, jbig2dec
, libGL
, libdrm
, libinput
, libjpeg
, libpng
, libpulseaudio
, libraw
, librsvg
, libsndfile
, libspectre
, libtiff
, libwebp
, libxkbcommon
, luajit
, lz4
, mesa
, mint-x-icons
, openjpeg
, openssl
, poppler
, python3Packages
, systemd
, udev
, utillinux
, writeText
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "efl";
  version = "1.24.3";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "de95c6e673c170c1e21382918b122417c091c643e7dcaced89aa785529625c2a";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
    pkgconfig
    check
  ];

  buildInputs = [
    fontconfig
    freetype
    giflib
    glib
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    ibus
    libGL
    libpng
    libpulseaudio
    libsndfile
    libtiff
    lz4
    mesa
    openssl
    systemd
    udev
    xorg.libX11
    xorg.libXcursor
    xorg.xorgproto
    zlib
    # still missing parent icon themes: RAVE-X, Faenza
  ];

  propagatedBuildInputs = [
    SDL2
    alsaLib
    bullet
    curl
    dbus
    dbus
    doxygen
    expat
    fribidi
    ghostscript
    harfbuzz
    hicolor-icon-theme # for the icon theme
    jbig2dec
    libdrm
    libinput
    libjpeg
    libraw
    librsvg
    libspectre
    libwebp
    libxkbcommon
    luajit
    mint-x-icons # Mint-X is a parent icon theme of Enlightenment-X
    openjpeg
    poppler
    utillinux
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
  ];

  dontDropIconThemeCache = true;

  mesonFlags = [
    "--buildtype=release"
    "-D build-tests=false" # disable build tests, which are not working
    "-D drm=true"
    "-D ecore-imf-loaders-disabler=ibus,scim" # ibus is disalbed by default, scim is not availabe in nixpkgs
    "-D embedded-lz4=false"
    "-D fb=true"
    "-D network-backend=connman"
    "-D sdl=true"
  ];

  patches = [
    ./efl-elua.patch
    ./0002-efreet-more-stat-info-changes.patch
  ];

  postPatch = ''
    patchShebangs src/lib/elementary/config_embed

    # fix destination of systemd unit and dbus service
    substituteInPlace systemd-services/meson.build --replace "sys_dep.get_pkgconfig_variable('systemduserunitdir')" "'$out/systemd/user'"
    substituteInPlace dbus-services/meson.build --replace "dep.get_pkgconfig_variable('session_bus_services_dir')" "'$out/share/dbus-1/services'"
  '';

  # bin/edje_cc creates $HOME/.run, which would break build of reverse dependencies.
  setupHook = writeText "setupHook.sh" ''
    export HOME="$TEMPDIR"
  '';

  preConfigure = ''
    # allow ecore_con to find libcurl.so, which is a runtime dependency (it is dlopened)
    export LD_LIBRARY_PATH="${curl.out}/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"

    source "$setupHook"
  '';

  NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

  postInstall = ''
    # fix use of $out variable
    substituteInPlace "$out/share/elua/core/util.lua" --replace '$out' "$out"

    # add all module include dirs to the Cflags field in efl.pc
    modules=$(for i in "$out/include/"*/; do printf ' -I''${includedir}/'`basename $i`; done)
    substituteInPlace "$out/lib/pkgconfig/efl.pc" \
      --replace 'Cflags: -I''${includedir}/efl-1' \
                'Cflags: -I''${includedir}/eina-1/eina'"$modules"

    # build icon cache
    gtk-update-icon-cache "$out"/share/icons/Enlightenment-X
  '';

  postFixup = ''
    # EFL applications depend on libcurl, which is linked at runtime by hand in code (it is dlopened)
    patchelf --add-needed ${curl.out}/lib/libcurl.so $out/lib/libecore_con.so
  '';

  meta = {
    description = "Enlightenment foundation libraries";
    homepage = "https://enlightenment.org/";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
