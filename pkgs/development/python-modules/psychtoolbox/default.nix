{ lib
, buildPythonPackage
, fetchPypi
, numpy
, xorg
, alsa-lib
, portaudio
, pkg-config
, libusb
, ffmpeg-full
, gamemode
}:

buildPythonPackage rec {
  pname = "psychtoolbox";
  version = "3.0.19.0";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-91l0spXWnx5PwI7xqPYq5+XH9GlDSTokF1UUyMjEGQ8=";
  };

  C_INCLUDE_PATH = "${libusb.dev}/include/libusb-1.0:${xorg.libXi.dev}/include:${xorg.libXext.dev}/include:${xorg.libXfixes.dev}/include";
  nativeBuildInputs = [
    pkg-config
    ffmpeg-full
  ];
  buildInputs = [
    xorg.libX11
    alsa-lib
    portaudio
    libusb
    xorg.libXi
    ffmpeg-full
  ];
  propagatedBuildInputs = [
    numpy
  ];
  postPatch = ''
    echo $C_INCLUDE_PATH
    substituteInPlace PsychSourceGL/Source/Linux/Base/gamemode_client.h \
      --replace "libgamemode.so.0" "${gamemode.lib}/lib/libgamemode.so"
    substituteInPlace PsychSourceGL/Source/Common/Screen/PsychWindowSupport.c \
      --replace "libusb-1.0.so.0" "${libusb}/lib/libusb-1.0.so.0"
  '';

  meta = with lib; {
    homepage = "https://psychtoolbox.org";
    description = "A set of Matlab and GNU Octave functions for vision and neuroscience research";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
