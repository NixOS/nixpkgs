{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "duet";
  version = "0.2.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "google";
    repo = "duet";
    rev = "refs/tags/v${version}";
    hash = "sha256-P7JxUigD7ZyhtocV+YuAVxuUYVa4F7PpXuA1CCmcMvg=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "duet" ];

  meta = with lib; {
    description = "Simple future-based async library for python";
    homepage = "https://github.com/google/duet";
    maintainers = with maintainers; [ drewrisinger ];
  };
}
