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
    sha256 = "15ag4al9h6b8f8sw1zpighyhsmr5qfqp1882q7r3gsh5g4cnj763";
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
