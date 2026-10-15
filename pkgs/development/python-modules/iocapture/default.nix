{
  lib,
  buildPythonPackage,
  fetchPypi,
  flexmock,
  pytestCheckHook,
  pytest-cov-stub,
  six,
}:

buildPythonPackage rec {
  pname = "iocapture";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hmcOGAi83NT3ARL0Pacq52bwTNgxHRBxzm4OCnLjfug=";
  };

  nativeCheckInputs = [
    flexmock
    pytestCheckHook
    pytest-cov-stub
    six
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Capture stdout, stderr easily";
    homepage = "https://github.com/oinume/iocapture";
    license = lib.licenses.mit;
  };
}
