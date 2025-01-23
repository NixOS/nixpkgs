{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "iterable-io";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "iterable-io";
    tag = "v${version}";
    hash = "sha256-+PSINKS7/FeGHYvkOASA5m+1pBpKfURfylZ8CwKijgA=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "iterableio" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library to adapt iterables to a file-like interface";
    homepage = "https://github.com/pR0Ps/iterable-io";
    changelog = "https://github.com/pR0Ps/iterable-io/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.mjoerg ];
  };
}
