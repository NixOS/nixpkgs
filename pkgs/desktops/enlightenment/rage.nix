{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, gst_all_1, pcre, mesa, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "rage";
  version = "0.3.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "04fdk23bbgvni212zrfy4ndg7vmshbsjgicrhckdvhay87pk9i75";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    mesa.dev
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
    homepage = "https://enlightenment.org/";
    maintainers = with stdenv.lib.maintainers; [ matejc ftrvxmtrx romildo ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
