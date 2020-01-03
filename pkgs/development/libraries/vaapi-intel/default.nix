{ stdenv, fetchFromGitHub, autoreconfHook, gnum4, pkgconfig, python2
, intel-gpu-tools, libdrm, libva, libX11, libGL, wayland, libXext
, enableHybridCodec ? false, vaapi-intel-hybrid
}:

stdenv.mkDerivation rec {
  pname = "intel-vaapi-driver";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "intel-vaapi-driver";
    rev    = version;
    sha256 = "019w0hvjc9l85yqhy01z2bvvljq208nkb43ai2v377l02krgcrbl";
  };

  patchPhase = ''
    patchShebangs ./src/shaders/gpp.py
  '';

  preConfigure = ''
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  postInstall = stdenv.lib.optionalString enableHybridCodec ''
    ln -s ${vaapi-intel-hybrid}/lib/dri/* $out/lib/dri/
  '';

  configureFlags = [
    "--enable-drm"
    "--enable-x11"
    "--enable-wayland"
  ] ++ stdenv.lib.optional enableHybridCodec "--enable-hybrid-codec";

  nativeBuildInputs = [ autoreconfHook gnum4 pkgconfig python2 ];

  buildInputs = [ intel-gpu-tools libdrm libva libX11 libXext libGL wayland ]
    ++ stdenv.lib.optional enableHybridCodec vaapi-intel-hybrid;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxmedia;
    license = licenses.mit;
    description = "Intel driver for the VAAPI library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
