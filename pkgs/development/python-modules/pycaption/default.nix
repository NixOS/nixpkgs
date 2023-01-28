{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, beautifulsoup4
, lxml
, cssutils
, pytest-lazy-fixture
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycaption";
  version = "2.1.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mV//EYdP7wKYD3Vc49z6LQVQeOuhzNKFZLf28RYdABk=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    cssutils
  ];

  nativeCheckInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/pbs/pycaption/blob/${version}/docs/changelog.rst";
    description = "Closed caption converter";
    homepage = "https://github.com/pbs/pycaption";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
