{ stdenv, fetchurl, autoreconfHook, pkgconfig, cmrt, libdrm, libva, libX11, libGL, wayland }:

stdenv.mkDerivation rec {
  name = "intel-hybrid-driver-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/01org/intel-hybrid-driver/archive/${version}.tar.gz";
    sha256 = "0ywdhbvzwzzrq4qhylnw1wc8l3j67h26l0cs1rncwhw05s3ndk8n";
  };

  patches = [
    # driver_init: load libva-x11.so for any ABI version
    (fetchurl {
      url = https://github.com/01org/intel-hybrid-driver/pull/26.diff;
      sha256 = "1ql4mbi5x1d2a5c8mkjvciaq60zj8nhx912992winbhfkyvpb3gx";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ cmrt libdrm libva libX11 libGL wayland ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-drm"
    "--enable-x11"
    "--enable-wayland"
  ];

  postPatch = ''
    patchShebangs ./src/shaders/gpp.py
  '';

  preConfigure = ''
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxmedia;
    description = "Intel driver for the VAAPI library with partial HW acceleration";
    license = licenses.mit;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.linux;
  };
}
