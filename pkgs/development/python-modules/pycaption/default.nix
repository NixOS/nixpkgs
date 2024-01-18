{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
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

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pbs";
    repo = "pycaption";
    rev = version;
    hash = "sha256-IPCU9MsBY+Vsk6SrR9+3j4Izfhw5LeUrK0KUa3seSs4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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

  meta = with lib; {
    changelog = "https://github.com/pbs/pycaption/blob/${version}/docs/changelog.rst";
    description = "Closed caption converter";
    homepage = "https://github.com/pbs/pycaption";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
