{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "nvidia-optical-flow-sdk";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "NVIDIAOpticalFlowSDK";
    rev = "79c6cee80a2df9a196f20afd6b598a9810964c32";
    sha256 = "1y6igwv75v1ynqm7j6la3ky0f15mgnj1jyyak82yvhcsx1aax0a1";
  };

  # # We only need the header files. The library files are
  # # in the nvidia_x11 driver.
  installPhase = ''
    mkdir -p $out/include
    cp -R * $out/include
  '';

  meta = with stdenv.lib; {
    description = "Nvidia optical flow headers for computing the relative motion of pixels between images";
    homepage = "https://developer.nvidia.com/opticalflow-sdk";
    license = licenses.bsd3; # applies to the header files only
    platforms = platforms.all;
  };
}

