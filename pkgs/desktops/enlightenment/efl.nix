{ stdenv, fetchurl, pkgconfig, openssl, libjpeg, zlib, lz4, freetype, fontconfig
, fribidi, SDL2, SDL, mesa, giflib, libpng, libtiff, glib, gst_all_1, libpulseaudio
, libsndfile, xorg, libdrm, libxkbcommon, udev, utillinux, dbus, bullet, luajit
, python27Packages, openjpeg, doxygen, expat, harfbuzz, jbig2dec, librsvg
, dbus_libs, alsaLib, poppler, ghostscript, libraw, libspectre, xineLib, libwebp
, curl, libinput, systemd, writeText
}:

stdenv.mkDerivation rec {
  name = "efl-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/efl/${name}.tar.xz";
    sha256 = "0zll6k4xbbdsxqg53g8jddgv889g5m1xh20i03iz5a52y2bcnh55";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl zlib lz4 freetype fontconfig SDL mesa
    giflib libpng libtiff glib gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gst_all_1.gst-libav libpulseaudio libsndfile xorg.libXcursor xorg.printproto
    xorg.libX11 udev systemd ];

  propagatedBuildInputs = [ libxkbcommon python27Packages.dbus-python dbus libjpeg xorg.libXcomposite
    xorg.libXdamage xorg.libXinerama xorg.libXp xorg.libXtst xorg.libXi xorg.libXext
    bullet xorg.libXScrnSaver xorg.libXrender xorg.libXfixes xorg.libXrandr
    xorg.libxkbfile xorg.libxcb xorg.xcbutilkeysyms openjpeg doxygen expat luajit
    harfbuzz jbig2dec librsvg dbus_libs alsaLib poppler ghostscript libraw libspectre xineLib libwebp curl libdrm
    libinput utillinux fribidi SDL2 ];

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
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Enlightenment foundation libraries";
    homepage = http://enlightenment.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
