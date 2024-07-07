{
  lib,
  buildPythonPackage,
  fetchPypi,
  greenlet,
  pytest,
  decorator,
  twisted,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-twisted";
  version = "1.14.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qbGLyfykfSiG+O/j/SeHmoHxwLtJ8cVgZmyedkSRtjI=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    decorator
    greenlet
  ];

  nativeCheckInputs = [
    pytestCheckHook
    twisted
  ];

  pythonImportsCheck = [ "pytest_twisted" ];

  meta = with lib; {
    description = "Twisted plugin for py.test";
    homepage = "https://github.com/pytest-dev/pytest-twisted";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
