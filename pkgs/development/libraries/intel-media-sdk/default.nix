{ stdenv, fetchurl, cmake, pkgconfig, gtest, libdrm, libpciaccess, libva, libX11
, libXau, libXdmcp, libpthreadstubs }:

stdenv.mkDerivation rec {
  pname = "intel-media-sdk";
  version = "20.1.1";

  src = fetchurl {
    url = "https://github.com/Intel-Media-SDK/MediaSDK/archive/intel-mediasdk-${version}.tar.gz";
    sha256 = "1p13b4abslq31pbgqf0bzs2ixns85yfdsm94326h2vcg0q7hqc24";
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
    description = "Intel Media SDK.";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    platforms = [ "x86_64-linux" ];
  };
}
