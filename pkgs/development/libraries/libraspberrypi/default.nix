{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libraspberrypi";
  version = "unstable-2020-11-30";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "093b30bbc2fd083d68cc3ee07e6e555c6e592d11";
    sha256 = "0n2psqyxlsic9cc5s8h65g0blblw3xws4czhpbbgjm58px3822d7";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    (if (stdenv.targetPlatform.system == "aarch64-linux") then "-DARM64=ON" else "-DARM64=OFF")
    "-DVMCS_INSTALL_PREFIX=$out"
  ];

  meta = with stdenv.lib; {
    description = "Userland libraries for interfacing with Raspberry Pi hardware";
    homepage = "https://github.com/raspberrypi/userland";
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ tkerber ];
  };
}
