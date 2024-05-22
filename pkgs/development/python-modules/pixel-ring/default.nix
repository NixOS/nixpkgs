{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pyusb,
  spidev,
}:

buildPythonPackage rec {
  pname = "pixel-ring";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "respeaker";
    repo = "pixel_ring";
    rev = version;
    hash = "sha256-J9kScjD6Xon0YWGxFU881bIbjmDpY7cnWzJ8G0SOKaw=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    pyusb
    spidev
  ];

  dontUsePythonImportsCheck = true; # requires SPI access

  doCheck = false; # no tests

  meta = with lib; {
    description = "RGB LED library for ReSpeaker 4 Mic Array, ReSpeaker V2 & ReSpeaker USB 6+1 Mic Array";
    mainProgram = "pixel_ring_check";
    homepage = "https://github.com/respeaker/pixel_ring/tree/master";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ hexa ];
  };
}
