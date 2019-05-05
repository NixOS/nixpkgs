{ stdenv, fetchurl, pkgconfig, openssl, libjpeg, zlib, lz4, freetype, fontconfig
, fribidi, SDL2, SDL, libGL, giflib, libpng, libtiff, glib, gst_all_1, libpulseaudio
, libsndfile, xorg, libdrm, libxkbcommon, udev, utillinux, bullet, luajit
, python27Packages, openjpeg, doxygen, expat, harfbuzz, jbig2dec, librsvg
, dbus, alsaLib, poppler, ghostscript, libraw, libspectre, xineLib, libwebp
, curl, libinput, systemd, mesa_noglu, writeText, gtk3
}:

stdenv.mkDerivation rec {
  name = "efl-${version}";
  version = "1.22.2";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/efl/${name}.tar.xz";
    sha256 = "1l0wdgzxqm2y919277b1p9d37xzg808zwxxaw0nn44arh8gqk68n";
  };

  nativeBuildInputs = [ pkgconfig gtk3 ];

  buildInputs = [ openssl zlib lz4 freetype fontconfig SDL libGL mesa_noglu
    giflib libpng libtiff glib gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gst_all_1.gst-libav libpulseaudio libsndfile xorg.libXcursor xorg.xorgproto
    xorg.libX11 udev systemd ];

  propagatedBuildInputs = [ libxkbcommon python27Packages.dbus-python dbus libjpeg xorg.libXcomposite
    xorg.libXdamage xorg.libXinerama xorg.libXp xorg.libXtst xorg.libXi xorg.libXext
    bullet xorg.libXScrnSaver xorg.libXrender xorg.libXfixes xorg.libXrandr
    xorg.libxkbfile xorg.libxcb xorg.xcbutilkeysyms openjpeg doxygen expat luajit
    harfbuzz jbig2dec librsvg dbus alsaLib poppler ghostscript libraw libspectre xineLib libwebp curl libdrm
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
    homepage = http://enlightenment.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
