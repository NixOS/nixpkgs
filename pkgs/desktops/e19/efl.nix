{ stdenv, fetchurl, pkgconfig, openssl, libjpeg, zlib, freetype, fontconfig, fribidi, SDL2, SDL, mesa, giflib, libpng, libtiff, glib, gst_all_1, pulseaudio, libsndfile, xlibs, libdrm, libxkbcommon, udev, utillinuxCurses, dbus, bullet, luajit, python27Packages, openjpeg, doxygen, expat, lua5_2, harfbuzz, jbig2dec, librsvg, dbus_libs, alsaLib, poppler, libraw, libspectre, xineLib, vlc, libwebp, curl, libinput }:


stdenv.mkDerivation rec {
  name = "efl-${version}";
  version = "1.13.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/efl/${name}.tar.gz";
    sha256 = "0wjy2n2ggjd9mzv9y0ra21wfjdbw927hdh6pz537p820bnghcivy";
  };

  buildInputs = [ pkgconfig openssl zlib freetype fontconfig fribidi SDL2 SDL mesa
    giflib libpng libtiff glib gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gst_all_1.gst-libav pulseaudio libsndfile xlibs.libXcursor xlibs.printproto
    xlibs.libX11 udev utillinuxCurses luajit ];

  propagatedBuildInputs = [ libxkbcommon python27Packages.dbus dbus libjpeg xlibs.libXcomposite
    xlibs.libXdamage xlibs.libXinerama xlibs.libXp xlibs.libXtst xlibs.libXi xlibs.libXext
    bullet xlibs.libXScrnSaver xlibs.libXrender xlibs.libXfixes xlibs.libXrandr
    xlibs.libxkbfile xlibs.libxcb xlibs.xcbutilkeysyms openjpeg doxygen expat lua5_2
    harfbuzz jbig2dec librsvg dbus_libs alsaLib poppler libraw libspectre xineLib vlc libwebp curl libdrm
    libinput ];

  # ac_ct_CXX must be set to random value, because then it skips some magic which does alternative searching for g++
  configureFlags = [ "--with-tests=none" "--enable-sdl" "--enable-drm" "--with-opengl=full"
    "--enable-image-loader-jp2k" "--enable-xinput22" "--enable-multisense" "--enable-systemd"
    "--enable-image-loader-webp" "--enable-harfbuzz" "--enable-xine" "--enable-fb"
    "--disable-tslib" "--with-systemdunitdir=$out/systemd/user" "--enable-lua-old"
    "ac_ct_CXX=foo" ];

  NIX_CFLAGS_COMPILE = [ "-I${xlibs.libXtst}" "-I${dbus_libs}/include/dbus-1.0" "-I${dbus_libs}/lib/dbus-1.0/include" ];

  preConfigure = ''
    export PKG_CONFIG_PATH="${gst_all_1.gst-plugins-base}/lib/pkgconfig/gstreamer-video-0.10.pc:$PKG_CONFIG_PATH"
  '';

  enableParallelBuilding = true;

  setupHook = ./efl-setup-hook.sh;

  meta = {
    description = "Enlightenment Core libraries";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
  };
}
