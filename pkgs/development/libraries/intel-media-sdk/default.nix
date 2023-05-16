{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, gtest, libdrm, libpciaccess, libva, libX11
, libXau, libXdmcp, libpthreadstubs }:

stdenv.mkDerivation rec {
  pname = "intel-media-sdk";
<<<<<<< HEAD
  version = "23.2.2";
=======
  version = "23.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Intel-Media-SDK";
    repo = "MediaSDK";
    rev = "intel-mediasdk-${version}";
<<<<<<< HEAD
    hash = "sha256-wno3a/ZSKvgHvZiiJ0Gq9GlrEbfHCizkrSiHD6k/Loo=";
=======
    hash = "sha256-XxwB5C1NBjq6cjlfzYmvudH6dlItFYSU9dd5DwH7tH0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    libdrm libva libpciaccess libX11 libXau libXdmcp libpthreadstubs
  ];
  nativeCheckInputs = [ gtest ];

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
