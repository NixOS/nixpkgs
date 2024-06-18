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
}:

buildPythonPackage rec {
  pname = "pyudev";
  version = "0.24.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-deVNNyGPWsRbDaHw/ZzF5SajysPvHPrUEM96sziwFHE=";
  };

  postPatch = lib.optionalString stdenvNoCC.isLinux ''
    substituteInPlace src/pyudev/_ctypeslib/utils.py \
      --replace "find_library(name)" "'${lib.getLib udev}/lib/libudev.so'"
  '';

  nativeCheckInputs = [
    pytest
    mock
    hypothesis
    docutils
  ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  # Bunch of failing tests
  # https://github.com/pyudev/pyudev/issues/187
  doCheck = false;

  meta = with lib; {
    homepage = "https://pyudev.readthedocs.org/";
    description = "Pure Python libudev binding";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ frogamic ];
  };
}
