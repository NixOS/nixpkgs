{ stdenv, fetchurl, gnum4, pkgconfig, python2, autoreconfHook
, intel-gpu-tools, libdrm, libva, libX11, mesa_noglu, wayland
}:

stdenv.mkDerivation rec {
  name = "libva-intel-driver-g45-h264-${version}";
  version = "1.8.2";

  src = fetchurl {
    url = "https://bitbucket.org/alium/g45-h264/downloads/intel-driver-g45-h264-${version}.tar.gz";
    sha256 = "0a93nbznnikkqf3ry417jzpzwz1s3hc9ys0jckqsnm9mr29cxbw6";
  };

  patches = [ ./fix_surface_querys.patch ];

  postPatch = ''
    patchShebangs ./src/shaders/gpp.py
  '';

  preConfigure = ''
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  configureFlags = [
    "--enable-drm"
    "--enable-x11"
    "--enable-wayland"
  ];

  nativeBuildInputs = [ gnum4 pkgconfig python2 autoreconfHook ];

  buildInputs = [ intel-gpu-tools libdrm libva libX11 mesa_noglu wayland ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/alium/g45-h264/downloads/;
    license = licenses.mit;
    description = "VAAPI library driver with H264 support for Intel G45 chipsets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
