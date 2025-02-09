{ buildPythonPackage
, fetchPypi
, lib
, pytest
, pytest-xdist
, pytest-dependency
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-order";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lE+GttRBqnsdqA+AHGq2W4S766Ry0KehLrQ7omZQEBo=";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-dependency
    pytest-mock
  ];

  meta = {
    description = "Pytest plugin that allows you to customize the order in which your tests are run";
    homepage = "https://github.com/pytest-dev/pytest-order";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jacg ];
  };
}
