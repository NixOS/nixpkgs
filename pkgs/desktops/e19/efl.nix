{ stdenv, fetchurl, pkgconfig, openssl, libjpeg, zlib, freetype, fontconfig, fribidi, SDL2, SDL, mesa, giflib, libpng, libtiff, glib, gst_all_1, libpulseaudio, libsndfile, xlibs, libdrm, libxkbcommon, udev, utillinuxCurses, dbus, bullet, luajit, python27Packages, openjpeg, doxygen, expat, harfbuzz, jbig2dec, librsvg, dbus_libs, alsaLib, poppler, libraw, libspectre, xineLib, vlc, libwebp, curl, libinput }:


stdenv.mkDerivation rec {
  name = "efl-${version}";
  version = "1.14.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/efl/${name}.tar.gz";
    sha256 = "16rj4qnpw1ya0bsp9a69w6zjmmhzni7vnc0z4wg819jg5k2njzjf";
  };

  buildInputs = [ pkgconfig openssl zlib freetype fontconfig fribidi SDL2 SDL mesa
    giflib libpng libtiff glib gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gst_all_1.gst-libav libpulseaudio libsndfile xlibs.libXcursor xlibs.printproto
    xlibs.libX11 udev utillinuxCurses ];

  propagatedBuildInputs = [ libxkbcommon python27Packages.dbus dbus libjpeg xlibs.libXcomposite
    xlibs.libXdamage xlibs.libXinerama xlibs.libXp xlibs.libXtst xlibs.libXi xlibs.libXext
    bullet xlibs.libXScrnSaver xlibs.libXrender xlibs.libXfixes xlibs.libXrandr
    xlibs.libxkbfile xlibs.libxcb xlibs.xcbutilkeysyms openjpeg doxygen expat luajit
    harfbuzz jbig2dec librsvg dbus_libs alsaLib poppler libraw libspectre xineLib vlc libwebp curl libdrm
    libinput ];

  # ac_ct_CXX must be set to random value, because then it skips some magic which does alternative searching for g++
  configureFlags = [ "--with-tests=none" "--enable-sdl" "--enable-drm" "--with-opengl=full"
    "--enable-image-loader-jp2k" "--enable-xinput22" "--enable-multisense" "--enable-systemd"
    "--enable-image-loader-webp" "--enable-harfbuzz" "--enable-xine" "--enable-fb"
    "--disable-tslib" "--with-systemdunitdir=$out/systemd/user"
    "ac_ct_CXX=foo" ];

  NIX_CFLAGS_COMPILE = [ "-I${xlibs.libXtst}" "-I${dbus_libs}/include/dbus-1.0" "-I${dbus_libs}/lib/dbus-1.0/include" ];

  patches = [ ./efl-elua.patch ];

  preConfigure = ''
    export PKG_CONFIG_PATH="${gst_all_1.gst-plugins-base}/lib/pkgconfig/gstreamer-video-0.10.pc:$PKG_CONFIG_PATH"
    export LD_LIBRARY_PATH="$(pwd)/src/lib/eina/.libs:$LD_LIBRARY_PATH"
  '';

  postInstall = ''
    substituteInPlace "$out/share/elua/core/util.lua" --replace '$out' "$out"
    modules=$(for i in "$out/include/"*/; do printf ' -I''${includedir}/'`basename $i`; done)
    substituteInPlace "$out/lib/pkgconfig/efl.pc" --replace 'Cflags: -I''${includedir}/efl-1' \
      'Cflags: -I''${includedir}/eina-1/eina'"$modules"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Enlightenment Core libraries";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
  };
}
