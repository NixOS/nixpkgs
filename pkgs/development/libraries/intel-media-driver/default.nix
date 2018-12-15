{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, libva, libpciaccess, intel-gmmlib, libX11
}:

stdenv.mkDerivation rec {
  name = "intel-media-driver-${version}";
  version = "18.3.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "media-driver";
    rev    = "intel-media-${version}";
    sha256 = "15kcyg9ss2v1bbw6yvxqb833h1vs0h659n8ix0x5x03cfm1wsi57";
  };

  cmakeFlags = [ "-DINSTALL_DRIVER_SYSCONF=OFF" ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DLIBVA_DRIVERS_PATH=$out/lib/dri"
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libva libpciaccess intel-gmmlib libX11 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/intel/media-driver;
    license = with licenses; [ bsd3 mit ];
    description = "Intel Media Driver for VAAPI — Broadwell+ iGPUs";
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
