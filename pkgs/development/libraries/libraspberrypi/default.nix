{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libraspberrypi";
  version = "2019-10-22";
  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "5070cb7fc150fc98f1ed64a7739c3356970d9f76";
    sha256 = "08yfzwn9s7lhrblcsxyag9p5lj5vk3n66b1pv3f7r3hah7qcggyq";
  };

  cmakeFlags = if (stdenv.targetPlatform.system == "aarch64-linux")
    then "-DARM64=ON"
    else "-DARM64=OFF";
  preConfigure = ''cmakeFlags="$cmakeFlags -DVMCS_INSTALL_PREFIX=$out"'';
  nativeBuildInputs = [ cmake ];
  meta = with stdenv.lib; {
    description = "Userland libraries for interfacing with Raspberry Pi hardware";
    homepage = https://github.com/raspberrypi/userland;
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ tkerber ];
  };
}
