{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "nvidia-video-sdk-6.0.1";

  src = fetchurl {
    url = "https://developer.nvidia.com/video-sdk-601";
    name = "nvidia_video_sdk_6.0.1.zip";
    sha256 = "08h1vnqsv22js9v3pyim5yb80z87baxb7s2g5gsvvjax07j7w8h5";
  };

  buildInputs = [ unzip ];

  # We only need the header files. The library files are
  # in the nvidia_x11 driver.
  installPhase = ''
    mkdir -p $out/include
    cp -R Samples/common/inc/* $out/include
  '';

  meta = with stdenv.lib; {
    description = "The NVIDIA Video Codec SDK";
    homepage = https://developer.nvidia.com/nvidia-video-codec-sdk;
    license = licenses.unfree;
  };
}

