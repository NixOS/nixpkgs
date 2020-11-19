{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libraspberrypi";
  version = "2020-05-28";
  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "f97b1af1b3e653f9da2c1a3643479bfd469e3b74";
    sha256 = "1r7n05rv96hqjq0rn0qzchmfqs0j7vh3p8jalgh66s6l0vms5mwy";
  };

  cmakeFlags = if (stdenv.targetPlatform.system == "aarch64-linux")
    then "-DARM64=ON"
    else "-DARM64=OFF";
  preConfigure = ''cmakeFlags="$cmakeFlags -DVMCS_INSTALL_PREFIX=$out"'';
  nativeBuildInputs = [ cmake ];
  meta = with stdenv.lib; {
    description = "Userland libraries for interfacing with Raspberry Pi hardware";
    homepage = "https://github.com/raspberrypi/userland";
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ tkerber ];
  };
}
