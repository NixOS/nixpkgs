{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  nose,
  pytest,
  six,
}:

buildPythonPackage rec {
  pname = "mohawk";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0qDjqxCiCcx56V4o8t1UvUpz/RmY/+J7e6D5Yra+lyM=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    mock
    nose
    pytest
  ];

  checkPhase = ''
    pytest mohawk/tests.py
  '';

  meta = {
    description = "Python library for Hawk HTTP authorization";
    homepage = "https://github.com/kumar303/mohawk";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
