{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pylzma";
  version = "0.5.0";
  format = "setuptools";

  # This vendors an old LZMA SDK
  # After some discussion, it seemed most reasonable to keep it that way
  # xz, and uefi-firmware-parser also does this
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uHQXKvvzd3DmQ78tydm2sD65XY+BYuFXFFs/6eG2ihw=";
  };

  pythonImportsCheck = [ "pylzma" ];

  meta = with lib; {
    homepage = "https://www.joachim-bauch.de/projects/pylzma/";
    description = "Platform independent python bindings for the LZMA compression library";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
