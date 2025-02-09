{ lib
, buildPythonPackage
, fetchPypi
, flexmock
, pytest
, pytest-cov
, six
}:

buildPythonPackage rec {
  pname = "iocapture";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86670e1808bcdcd4f70112f43da72ae766f04cd8311d1071ce6e0e0a72e37ee8";
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
    description = "Capture stdout, stderr easily.";
    homepage = "https://github.com/oinume/iocapture";
    license = licenses.mit;
  };
}
