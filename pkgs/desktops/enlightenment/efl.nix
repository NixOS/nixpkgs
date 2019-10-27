{ stdenv, fetchurl, pkgconfig, SDL, SDL2, alsaLib, bullet, curl, dbus,
  doxygen, expat, fontconfig, freetype, fribidi, ghostscript, giflib,
  glib, gst_all_1, gtk3, harfbuzz, jbig2dec, libGL, libdrm, libinput,
  libjpeg, libpng, libpulseaudio, libraw, librsvg, libsndfile,
  libspectre, libtiff, libwebp, libxkbcommon, luajit, lz4, mesa,
  openjpeg, openssl, poppler, python27Packages, systemd, udev,
  utillinux, writeText, xineLib, xorg, zlib
}:

stdenv.mkDerivation rec {
  pname = "efl";
  version = "1.22.5";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1cjk56z0whpzcqwg3xdq23kyp1g83xa67m9dlp7ywmb36bn4ca59";
  };

  nativeBuildInputs = [
    gtk3
    pkgconfig
  ];

  buildInputs = [
    SDL
    fontconfig
    freetype
    giflib
    glib
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
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
    openjpeg
    poppler
    python27Packages.dbus-python
    utillinux
    xineLib
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXp
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    xorg.xcbutilkeysyms
  ];

  # ac_ct_CXX must be set to random value, because then it skips some magic which does alternative searching for g++
  configureFlags = [
    "--enable-sdl"
    "--enable-drm"
    "--enable-elput"
    "--with-opengl=full"
    "--enable-image-loader-jp2k"
    "--enable-xinput22"
    "--enable-multisense"
    "--enable-liblz4"
    "--enable-systemd"
    "--enable-image-loader-webp"
    "--enable-harfbuzz"
    "--enable-xine"
    "--enable-fb"
    "--disable-tslib"
    "--with-systemdunitdir=$out/systemd/user"
    "ac_ct_CXX=foo"
  ];

  patches = [ ./efl-elua.patch ];

  postPatch = ''
    patchShebangs src/lib/elementary/config_embed
  '';

  # bin/edje_cc creates $HOME/.run, which would break build of reverse dependencies.
  setupHook = writeText "setupHook.sh" ''
    export HOME="$TEMPDIR"
  '';

  preConfigure = ''
    export LD_LIBRARY_PATH="$(pwd)/src/lib/eina/.libs:$LD_LIBRARY_PATH"
    source "$setupHook"
  '';

  NIX_CFLAGS_COMPILE = [ "-DluaL_reg=luaL_Reg" ]; # needed since luajit-2.1.0-beta3

  postInstall = ''
    substituteInPlace "$out/share/elua/core/util.lua" --replace '$out' "$out"
    modules=$(for i in "$out/include/"*/; do printf ' -I''${includedir}/'`basename $i`; done)
    substituteInPlace "$out/lib/pkgconfig/efl.pc" --replace 'Cflags: -I''${includedir}/efl-1' \
      'Cflags: -I''${includedir}/eina-1/eina'"$modules"

    # build icon cache
    gtk-update-icon-cache "$out"/share/icons/Enlightenment-X
  '';

  # EFL applications depend on libcurl, although it is linked at
  # runtime by hand in code (it is dlopened).
  postFixup = ''
    patchelf --add-needed ${curl.out}/lib/libcurl.so $out/lib/libecore_con.so
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Enlightenment foundation libraries";
    homepage = https://enlightenment.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
