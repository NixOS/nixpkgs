{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylzma";
  version = "0.6.0";
  pyproject = true;

  # This vendors an old LZMA SDK
  # After some discussion, it seemed most reasonable to keep it that way
  # xz, and uefi-firmware-parser also does this
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OwCniSKNBaBvqZXNK0H/SpZXhKoZSKBthLPKa4cwQfA=";
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
