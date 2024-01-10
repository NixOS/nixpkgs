{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, beautifulsoup4
, lxml
, cssutils
, nltk
, pytest-lazy-fixture
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycaption";
  version = "2.2.1";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fYhxHC2pQD16GF6fm7ZiyljaLtORa0yuV9hcKntzPAI=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    cssutils
  ];

  passthru.optional-dependencies = {
    transcript = [ nltk ];
  };

  nativeCheckInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/pbs/pycaption/blob/${version}/docs/changelog.rst";
    description = "Closed caption converter";
    homepage = "https://github.com/pbs/pycaption";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
