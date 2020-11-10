{ stdenv, fetchFromGitHub, cmake, pkgconfig, gtest, libdrm, libpciaccess, libva, libX11
, libXau, libXdmcp, libpthreadstubs }:

stdenv.mkDerivation rec {
  pname = "intel-media-sdk";
  version = "20.3.1";

  src = fetchFromGitHub {
    owner = "Intel-Media-SDK";
    repo = "MediaSDK";
    rev = "intel-mediasdk-${version}";
    sha256 = "13b698zp9b228x81yly0qx3zvj821niz3yad74b229i3z7rf8wzd";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    libdrm libva libpciaccess libX11 libXau libXdmcp libpthreadstubs
  ];
  checkInputs = [ gtest ];

  cmakeFlags = [
    "-DBUILD_SAMPLES=OFF"
    "-DBUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DUSE_SYSTEM_GTEST=ON"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Intel Media SDK";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    platforms = [ "x86_64-linux" ];
  };
}
