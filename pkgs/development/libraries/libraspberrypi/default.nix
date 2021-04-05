{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libraspberrypi";
  version = "unstable-2021-01-11";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "4a0a19b88b43e48c6b51b526b9378289fb712a4c";
    sha256 = "0g3a1a7w717h0fwk39banzgjwphh62fx64k130w2s5885lsn5r5k";
  };

  patches = [
    (fetchpatch {
      # https://github.com/raspberrypi/userland/pull/670
      url = "https://github.com/raspberrypi/userland/pull/670/commits/37cb44f314ab1209fe2a0a2449ef78893b1e5f62.patch";
      sha256 = "1fbrbkpc4cc010ji8z4ll63g17n6jl67kdy62m74bhlxn72gg9rw";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  cmakeFlags = [
    (if (stdenv.hostPlatform.isAarch64) then "-DARM64=ON" else "-DARM64=OFF")
    "-DVMCS_INSTALL_PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Userland tools & libraries for interfacing with Raspberry Pi hardware";
    homepage = "https://github.com/raspberrypi/userland";
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ dezgeg tavyc tkerber ];
  };
}
