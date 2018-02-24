{ stdenv, fetchFromGitHub, autoreconfHook, gnum4, pkgconfig, python2
, intel-gpu-tools, libdrm, libva, libX11, libGL, wayland, libXext
}:

stdenv.mkDerivation rec {
  name = "intel-vaapi-driver-${version}";
  inherit (libva) version;

  src = fetchFromGitHub {
    owner  = "01org";
    repo   = "libva-intel-driver";
    rev    = version;
    sha256 = "1832nnva3d33wv52bj59bv62q7a807sdxjqqq0my7l9x7a4qdkzz";
  };

  patchPhase = ''
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

  nativeBuildInputs = [ autoreconfHook gnum4 pkgconfig python2 ];

  buildInputs = [ intel-gpu-tools libdrm libva libX11 libXext libGL wayland ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://cgit.freedesktop.org/vaapi/intel-driver/;
    license = licenses.mit;
    description = "Intel driver for the VAAPI library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}
