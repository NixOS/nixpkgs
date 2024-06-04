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
    sha256 = "08wppsv65yd0gdxy5zwq37yp6jmxakfz4a2yx5wwq2d222my786j";
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
    description = "Python library for Hawk HTTP authorization.";
    homepage = "https://github.com/kumar303/mohawk";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
