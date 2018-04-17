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
    (pkgconfig.override { vanilla = true; })
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

  meta = {
    description = "Video + Audio player along the lines of mplayer";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc ftrvxmtrx romildo ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
