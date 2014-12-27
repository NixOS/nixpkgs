{ stdenv, fetchurl, pkgconfig, openssl, libjpeg, zlib, freetype, fontconfig, fribidi, SDL2, SDL, mesa, giflib, libpng, libtiff, glib, gst_all_1, pulseaudio, libsndfile, xlibs, libdrm, libxkbcommon, udev, utillinuxCurses, dbus, bullet, luajit, python27Packages, openjpeg, doxygen, expat, lua5_2, harfbuzz, jbig2dec, librsvg, dbus_libs, alsaLib, poppler, libraw, libspectre, xineLib, vlc, libwebp, curl }:


stdenv.mkDerivation rec {
  name = "efl-${version}";
  version = "1.12.2";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/efl/${name}.tar.gz";
    sha256 = "1knxm4xiqxpvpszhyqik43lw36hdwdfh8z7y62803a7093j3yjnw";
  };

  buildInputs = [ pkgconfig openssl zlib freetype fontconfig fribidi SDL2 SDL mesa
    giflib libpng libtiff glib gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gst_all_1.gst-libav pulseaudio libsndfile xlibs.libXcursor xlibs.printproto
    xlibs.libX11 libdrm udev utillinuxCurses luajit ];

  propagatedBuildInputs = [ libxkbcommon python27Packages.dbus dbus libjpeg xlibs.libXcomposite
    xlibs.libXdamage xlibs.libXinerama xlibs.libXp xlibs.libXtst xlibs.libXi xlibs.libXext
    bullet xlibs.libXScrnSaver xlibs.libXrender xlibs.libXfixes xlibs.libXrandr
    xlibs.libxkbfile xlibs.libxcb xlibs.xcbutilkeysyms openjpeg doxygen expat lua5_2
    harfbuzz jbig2dec librsvg dbus_libs alsaLib poppler libraw libspectre xineLib vlc libwebp curl ];

  configureFlags = [ "--with-tests=none" "--enable-sdl" "--enable-drm" "--with-opengl=full"
    "--enable-image-loader-jp2k" "--enable-xinput22" "--enable-multisense" "--enable-systemd"
    "--enable-image-loader-webp" "--enable-harfbuzz" "--enable-xine" "--enable-fb"
    "--disable-tslib" "--with-systemdunitdir=$out/systemd/user" "--enable-lua-old" ];

  NIX_CFLAGS_COMPILE = [ "-I${xlibs.libXtst}" "-I${dbus_libs}/include/dbus-1.0" "-I${dbus_libs}/lib/dbus-1.0/include" ];

  preConfigure = ''
    export PKG_CONFIG_PATH="${gst_all_1.gst-plugins-base}/lib/pkgconfig/gstreamer-video-0.10.pc:$PKG_CONFIG_PATH"
  '';

  setupHook = ./efl-setup-hook.sh;

  meta = {
    description = "Enlightenment Core libraries";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
  };
}
