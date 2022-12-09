{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, SDL2
, alsa-lib
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
, util-linux
, wayland
, wayland-protocols
, writeText
, xorg
, zlib
, directoryListingUpdater
}:

stdenv.mkDerivation rec {
  pname = "efl";
  version = "1.26.3";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-2fg6oP2TNPRN7rTklS3A5RRGg6+seG/uvOYDCVFhfRU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
    pkg-config
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
    wayland-protocols
    xorg.libX11
    xorg.libXcursor
    xorg.xorgproto
    zlib
    # still missing parent icon themes: RAVE-X, Faenza
  ];

  propagatedBuildInputs = [
    SDL2
    alsa-lib
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
    util-linux
    wayland
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
    "-D ecore-imf-loaders-disabler=ibus,scim" # ibus is disabled by default, scim is not availabe in nixpkgs
    "-D embedded-lz4=false"
    "-D fb=true"
    "-D network-backend=connman"
    "-D sdl=true"
    "-D elua=true"
    "-D bindings=lua,cxx"
    # for wayland client support
    "-D wl=true"
    "-D drm=true"
  ];

  patches = [
    ./efl-elua.patch
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

  postInstall = ''
    # fix use of $out variable
    substituteInPlace "$out/share/elua/core/util.lua" --replace '$out' "$out"
    rm "$out/share/elua/core/util.lua.orig"

    # add all module include dirs to the Cflags field in efl.pc
    modules=$(for i in "$out/include/"*/; do printf ' -I''${includedir}/'`basename $i`; done)
    substituteInPlace "$out/lib/pkgconfig/efl.pc" \
      --replace 'Cflags: -I''${includedir}/efl-1' \
                'Cflags: -I''${includedir}/eina-1/eina'"$modules"

    # build icon cache
    gtk-update-icon-cache "$out"/share/icons/Enlightenment-X
  '';

  postFixup = ''
    # Some libraries are linked at runtime by hand in code (they are dlopened)
    patchelf --add-needed ${curl.out}/lib/libcurl.so $out/lib/libecore_con.so
    patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/libecore_audio.so
    patchelf --add-needed ${libsndfile.out}/lib/libsndfile.so $out/lib/libecore_audio.so
  '';

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "Enlightenment foundation libraries";
    homepage = "https://enlightenment.org/";
    license = with licenses; [ bsd2 lgpl2Only licenses.zlib ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ matejc ftrvxmtrx ] ++ teams.enlightenment.members;
  };
}
