{ stdenv, fetchFromGitHub, cmake, pkg-config, gtest, libdrm, libpciaccess, libva, libX11
, libXau, libXdmcp, libpthreadstubs }:

stdenv.mkDerivation rec {
  pname = "intel-media-sdk";
  version = "20.4.1";

  src = fetchFromGitHub {
    owner = "Intel-Media-SDK";
    repo = "MediaSDK";
    rev = "intel-mediasdk-${version}";
    sha256 = "0qnq43qjcmzkn6v2aymzi3kycndk9xw6m5f5g5sz5x53nz556bp0";
  };

  nativeBuildInputs = [ cmake pkg-config ];
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
