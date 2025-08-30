{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  py,
  pytest,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-random-order";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbasko";
    repo = "pytest-random-order";
    tag = "v${version}";
    hash = "sha256-c282PrdXxG7WChnkpLWe059OmtTOl1Mn6yWgMRfCjBA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    py
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "random_order" ];

  meta = with lib; {
    homepage = "https://github.com/jbasko/pytest-random-order";
    description = "Randomise the order of tests with some control over the randomness";
    changelog = "https://github.com/jbasko/pytest-random-order/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
