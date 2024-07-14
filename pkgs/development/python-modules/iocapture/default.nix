{
  lib,
  buildPythonPackage,
  fetchPypi,
  flexmock,
  pytest,
  pytest-cov,
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
    pytest
    pytest-cov
    six
  ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Capture stdout, stderr easily";
    homepage = "https://github.com/oinume/iocapture";
    license = licenses.mit;
  };
}
