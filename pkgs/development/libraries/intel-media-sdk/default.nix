{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, gtest, libdrm, libpciaccess, libva, libX11
, libXau, libXdmcp, libpthreadstubs }:

stdenv.mkDerivation rec {
  pname = "intel-media-sdk";
  version = "21.2.0";

  src = fetchFromGitHub {
    owner = "Intel-Media-SDK";
    repo = "MediaSDK";
    rev = "intel-mediasdk-${version}";
    sha256 = "sha256-LusgmvlWOMEQjy47IpA9IYcl/cUTSMmvxSwvV/ihs2g=";
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

  meta = with lib; {
    description = "Intel Media SDK";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    platforms = [ "x86_64-linux" ];
  };
}
