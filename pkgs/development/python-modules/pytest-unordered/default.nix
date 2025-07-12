{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-unordered";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utapyngo";
    repo = "pytest-unordered";
    tag = "v${version}";
    hash = "sha256-nANsX28+G8jcSe8X0dB6Tu3HYHd9ebGkh1AUx8Xq8HM=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_unordered" ];

  meta = with lib; {
    changelog = "https://github.com/utapyngo/pytest-unordered/blob/v${version}/CHANGELOG.md";
    description = "Test equality of unordered collections in pytest";
    homepage = "https://github.com/utapyngo/pytest-unordered";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
