{ stdenv, fetchurl, pkgconfig, efl, gst_all_1, curl, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "rage-${version}";
  version = "0.2.1";
  
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/rage/${name}.tar.gz";
    sha256 = "0xlxb1hmbnqcy088cqpj2i87hsd5h3da7d2f9afiavz0ssw4ll94";
  };

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    efl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    curl
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

  postInstall = ''
    wrapProgram $out/bin/rage --prefix LD_LIBRARY_PATH : ${curl.out}/lib
  '';

  meta = {
    description = "Video + Audio player along the lines of mplayer";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc ftrvxmtrx romildo ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
