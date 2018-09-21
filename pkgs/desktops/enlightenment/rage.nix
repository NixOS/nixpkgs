{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, gst_all_1, pcre, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "rage-${version}";
  version = "0.3.0";
  
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/rage/${name}.tar.xz";
    sha256 = "0gfzdd4jg78bkmj61yg49w7bzspl5m1nh6agqgs8k7qrq9q26xqy";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    #(pkgconfig.override { vanilla = true; })
    wrapGAppsHook
  ];

  buildInputs = [
    efl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    pcre
  ];

  # It seems that currently meson and vanilla pkg-config does work
  # well, or there is a bug in rage related to them. For now revert to
  # the default pkg-config (which is patched to disable resolving
  # private requirements, used by EFL) and explicitly list the include
  # directories that cannot be found because of that. See also
  # https://github.com/NixOS/nixpkgs/pull/28477
  NIX_CFLAGS_COMPILE = [
    "-I${efl}/include/efl-1"
    "-I${efl}/include/eina-1"
    "-I${efl}/include/eina-1/eina"
    "-I${efl}/include/eet-1"
    "-I${efl}/include/emile-1"
    "-I${efl}/include/evas-1"
    "-I${efl}/include/eo-1"
    "-I${efl}/include/ecore-1"
    "-I${efl}/include/ecore-evas-1"
    "-I${efl}/include/ecore-file-1"
    "-I${efl}/include/ecore-input-1"
    "-I${efl}/include/ecore-imf-1"
    "-I${efl}/include/ecore-con-1"
    "-I${efl}/include/edje-1"
    "-I${efl}/include/eldbus-1"
    "-I${efl}/include/efreet-1"
    "-I${efl}/include/ethumb-client-1"
    "-I${efl}/include/ethumb-1"
    "-I${efl}/include/emotion-1"
    "-I${efl}/include/eio-1"
  ];

  meta = {
    description = "Video + Audio player along the lines of mplayer";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc ftrvxmtrx romildo ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
