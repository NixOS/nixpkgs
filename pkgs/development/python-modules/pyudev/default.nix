{
  lib,
  fetchPypi,
  buildPythonPackage,
  six,
  udev,
  pytest,
  mock,
  hypothesis,
  docutils,
  stdenvNoCC,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyudev";
  version = "0.24.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-54i7mDcAsahO/C6IhisKUa8qmV1bhryZl1RlBc97Nrw=";
  };

  postPatch = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    substituteInPlace src/pyudev/_ctypeslib/utils.py \
      --replace "find_library(name)" "'${lib.getLib udev}/lib/libudev.so'"
  '';

  build-system = [ setuptools ];

  dependencies = [ six ];

  checkPhase = ''
    py.test
  '';

  # Bunch of failing tests
  # https://github.com/pyudev/pyudev/issues/187
  doCheck = false;

  nativeCheckInputs = [
    pytest
    mock
    hypothesis
    docutils
  ];

  meta = {
    homepage = "https://pyudev.readthedocs.org/";
    description = "Pure Python libudev binding";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ frogamic ];
  };
}
