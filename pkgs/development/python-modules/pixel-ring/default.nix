{ lib
, buildPythonPackage
, fetchFromGitHub

# runtime
, pyusb
, spidev
}:

let
  version = "0.1.0";
in
buildPythonPackage {
  pname = "pixel-ring";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "respeaker";
    repo = "pixel_ring";
    rev = version;
    hash = "sha256-J9kScjD6Xon0YWGxFU881bIbjmDpY7cnWzJ8G0SOKaw=";
  };

  propagatedBuildInputs = [
    pyusb
    spidev
  ];

  # no tests
  doCheck = false;

  # tries to communicate with SPI device on import
  pythonImportsCheck = [
  ];

  meta = with lib; {
    description = "RGB LED library for Respeaker Mic Arrays";
    longDescription = ''
       RGB LED library for ReSpeaker 4 Mic Array, ReSpeaker V2 & ReSpeaker USB 6+1 Mic Array.
    '';
    homepage = "https://github.com/respeaker/pixel_ring";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
