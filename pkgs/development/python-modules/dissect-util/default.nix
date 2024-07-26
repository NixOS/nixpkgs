{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-util";
  version = "3.17";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.util";
    rev = "refs/tags/${version}";
    hash = "sha256-uCmHvpZ5/TjUb9A8+GhaTAAEfCM9LxQdUDPWAvd7P7w=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.util" ];

  meta = with lib; {
    description = "Dissect module implementing various utility functions for the other Dissect modules";
    mainProgram = "dump-nskeyedarchiver";
    homepage = "https://github.com/fox-it/dissect.util";
    changelog = "https://github.com/fox-it/dissect.util/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
