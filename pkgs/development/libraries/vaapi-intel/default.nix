{ stdenv, fetchFromGitHub, autoreconfHook, gnum4, pkgconfig, python2
, intel-gpu-tools, libdrm, libva, libX11, libGL, wayland, libXext
, enableHybridCodec ? false, vaapi-intel-hybrid
}:

stdenv.mkDerivation rec {
  name = "intel-vaapi-driver-${version}";
  # TODO: go back to stable releases with the next stable release after 2.3.0.
  #       see: https://github.com/NixOS/nixpkgs/issues/55975 (and the libva comment v)
  rev = "329975c63123610fc750241654a3bd18add75beb"; # generally try to match libva version, but not required
  version = "git-20190211";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "intel-vaapi-driver";
    rev    = rev;
    sha256 = "10333wh2d0hvz5lxl3gjvqs71s7v9ajb0269b3bj5kbflj03v3n5";
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
    maintainers = with maintainers; [ garbas ];
  };
}
