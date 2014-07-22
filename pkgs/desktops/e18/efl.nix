{ stdenv, fetchurl, pkgconfig, openssl, libjpeg, zlib, freetype, fontconfig, fribidi, SDL, mesa, giflib, libpng, libtiff, glib, gst_all_1, pulseaudio, libsndfile, xlibs, wayland, libdrm, libxkbcommon, udev, utillinuxCurses, dbus, bullet, luajit, python27Packages }:
stdenv.mkDerivation rec {
  name = "efl-${version}";
  version = "1.10.2";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/efl/${name}.tar.gz";
    sha256 = "0py8x0kv2hgl5v983xb6653fvmvn20im6picpc0hqfyxy09g1b24";
  };
  buildInputs = [ pkgconfig openssl zlib freetype fontconfig fribidi SDL mesa giflib libpng libtiff glib gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-libav pulseaudio libsndfile xlibs.libXcursor xlibs.printproto xlibs.libX11 libdrm udev utillinuxCurses luajit ];
  propagatedBuildInputs = [ wayland libxkbcommon python27Packages.dbus dbus libjpeg xlibs.libXcomposite xlibs.libXdamage xlibs.libXinerama xlibs.libXp xlibs.libXtst xlibs.libXi xlibs.libXext bullet xlibs.libXScrnSaver ];
  configureFlags = [ "--with-opengl=full" "--with-tests=none" "--enable-wayland" "--enable-sdl" "--enable-drm" ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${xlibs.libXtst} $NIX_CFLAGS_COMPILE"
    export PKG_CONFIG_PATH="${gst_all_1.gst-plugins-base}/lib/pkgconfig/gstreamer-video-0.10.pc:$PKG_CONFIG_PATH"
  '';
  meta = {
    description = "Enlightenment Core libraries";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
  };
}
