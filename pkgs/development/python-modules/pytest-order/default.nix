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
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2da32cb95e63fac6972d34f5ddb53997fc66305355425be0f55f4092d666293d";
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
    homepage = "https://github.com/mrbean-bremen/pytest-order";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jacg ];
  };
}
