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
  version = "2.2.5";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pbs";
    repo = "pycaption";
    rev = "refs/tags/${version}";
    hash = "sha256-zI5zRjvtsVgiIgWsQQgBQHhbYSGRBB6RLYgpbZWJQHs=";
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
