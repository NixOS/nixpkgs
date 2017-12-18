{ stdenv, fetchFromGitHub, autoreconfHook, gnum4, pkgconfig, python2
, intel-gpu-tools, libdrm, libva-full_1, libva-full_2, libX11, mesa_noglu, wayland, libXext
}:

let
  generic = sha256: vaLib: stdenv.mkDerivation rec {
    name = "intel-vaapi-driver-${version}";
    inherit (vaLib) version;

    src = fetchFromGitHub {
      owner  = "01org";
      repo   = "libva-intel-driver";
      rev    = version;
      inherit sha256;
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

    buildInputs = [ vaLib intel-gpu-tools libdrm libX11 libXext mesa_noglu wayland ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "Intel driver for the VAAPI library";
      homepage = http://cgit.freedesktop.org/vaapi/intel-driver/;
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
      platforms = platforms.unix;
    };
  };

in {
  vaapiIntel_1 = generic "0bcdcjzas3090m3nb0by8x26p30mdqfdh0g57yzxbsk22j75v8qp" libva-full_1;
  vaapiIntel_2 = generic "1832nnva3d33wv52bj59bv62q7a807sdxjqqq0my7l9x7a4qdkzz" libva-full_2;
}
