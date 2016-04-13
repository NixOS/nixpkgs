{ stdenv, fetchurl, elementary, efl, automake, autoconf, libtool, pkgconfig, gst_all_1
, makeWrapper, lib }:
stdenv.mkDerivation rec {
  name = "rage-${version}";
  version = "0.1.4";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/rage/${name}.tar.gz";
    sha256 = "10j3n8crk16jzqz2hn5djx6vms5f6x83qyiaphhqx94h9dgv2mgg";
  };
  buildInputs = [
    elementary efl automake autoconf libtool pkgconfig
    makeWrapper
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
 ];

  configurePhase = ''
    ./autogen.sh --prefix=$out
  '';

  postInstall = ''
    wrapProgram $out/bin/rage \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';
  meta = {
    description = "Video + Audio player along the lines of mplayer";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
