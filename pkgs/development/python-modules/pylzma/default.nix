{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylzma";
  version = "0.6.1";
  pyproject = true;

  # This vendors an old LZMA SDK
  # After some discussion, it seemed most reasonable to keep it that way
  # xz, and uefi-firmware-parser also does this
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qxzcUVFHnAZ0BEhn6OznXSUxVSceCpcC98sHa6aQ8p0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pylzma" ];

  meta = {
    homepage = "https://www.joachim-bauch.de/projects/pylzma/";
    description = "Platform independent python bindings for the LZMA compression library";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
