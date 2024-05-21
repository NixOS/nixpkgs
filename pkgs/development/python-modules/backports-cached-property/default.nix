{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, setuptools-scm, wheel
, pytestCheckHook, pytest-mock, pytest-sugar
}:

buildPythonPackage rec {
  pname = "backports-cached-property";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "penguinolog";
    repo = "backports.cached_property";
    rev = version;
    hash = "sha256-rdgKbVQaELilPrN4ve8RbbaLiT14Xex0esy5vUX2ZBc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-sugar
  ];

  pythonImportsCheck = [
    "backports.cached_property"
  ];

  meta = with lib; {
    description = "Python 3.8 functools.cached_property backport to python 3.6";
    homepage = "https://github.com/penguinolog/backports.cached_property";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ izorkin ];
  };
}
