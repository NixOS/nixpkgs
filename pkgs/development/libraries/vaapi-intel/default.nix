{ stdenv, fetchurl, gnum4, pkgconfig, python
, intel-gpu-tools, libdrm, libva, libX11, mesa_noglu, wayland
}:

stdenv.mkDerivation rec {
  name = "libva-intel-driver-1.6.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/${name}.tar.bz2";
    sha256 = "1zl51mdxfmnn33r4b0y5qxwlkqfw919aqphsq60d50pwrvdmk1xz";
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

  nativeBuildInputs = [ gnum4 pkgconfig python ];

  buildInputs = [ intel-gpu-tools libdrm libva libX11 mesa_noglu wayland ];

  meta = with stdenv.lib; {
    homepage = http://cgit.freedesktop.org/vaapi/intel-driver/;
    license = licenses.mit;
    description = "Intel driver for the VAAPI library";
    platforms = platforms.unix;
  };
}
