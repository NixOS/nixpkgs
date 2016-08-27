{ stdenv, fetchurl, efl, automake, autoconf, libtool, pkgconfig, gst_all_1
, makeWrapper, lib }:

stdenv.mkDerivation rec {
  name = "rage-${version}";
  version = "0.2.0";
  
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/rage/${name}.tar.gz";
    sha256 = "06fxhznwbd5x341r8ml3cpwmvwn0aq9i1akcgclk4vjdqiyff1d9";
  };

  nativeBuildInputs = [
    automake autoconf libtool pkgconfig makeWrapper
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${efl}/include/ecore-con-1"
    "-I${efl}/include/ecore-evas-1"
    "-I${efl}/include/ecore-file-1"
    "-I${efl}/include/ecore-imf-1"
    "-I${efl}/include/ecore-input-1"
    "-I${efl}/include/eet-1"
    "-I${efl}/include/efreet-1"
    "-I${efl}/include/eldbus-1"
    "-I${efl}/include/emile-1"
    "-I${efl}/include/eo-1"
    "-I${efl}/include/ethumb-1"
    "-I${efl}/include/ethumb-client-1"
  ];

  buildInputs = [
    efl
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
