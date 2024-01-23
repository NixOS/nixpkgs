{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pylint
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "pylint-plugin-utils";
  version = "0.8.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-plugin-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-xuPU1txfB+6+zJjtlfvNA950S5n7/PWPPFn1F3RtvCc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pylint
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylint_plugin_utils"
  ];

  # https://github.com/PyCQA/pylint-plugin-utils/issues/26
  doCheck = false;

  meta = with lib; {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = "https://github.com/PyCQA/pylint-plugin-utils";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
