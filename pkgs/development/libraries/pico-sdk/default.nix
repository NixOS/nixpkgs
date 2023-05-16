{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "pico-sdk";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-JNcxd86XNNiPkvipVFR3X255boMmq+YcuJXUP4JwInU=";
=======
    sha256 = "sha256-p69go8KXQR21szPb+R1xuonyFj+ZJDunNeoU7M3zIsE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  # SDK contains libraries and build-system to develop projects for RP2040 chip
  # We only need to compile pioasm binary
<<<<<<< HEAD
  sourceRoot = "${src.name}/tools/pioasm";
=======
  sourceRoot = "source/tools/pioasm";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pico-sdk
    cp -a ../../../* $out/lib/pico-sdk/
    chmod 755 $out/lib/pico-sdk/tools/pioasm/build/pioasm
    runHook postInstall
  '';

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://github.com/raspberrypi/pico-sdk";
=======
    homepage = "https://github.com/raspberrypi/picotool";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "SDK provides the headers, libraries and build system necessary to write programs for the RP2040-based devices";
    license = licenses.bsd3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.unix;
  };
}
