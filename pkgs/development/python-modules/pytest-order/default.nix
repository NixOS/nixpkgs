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
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Xda5KfvX6qbQ7gdYb2XGI7q7Cv5ytIQ8XxUFXWs7Gx8=";
  };

  buildInputs = [ pytest ];

  checkInputs = [
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
