{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pylint,
  pytestCheckHook,
  pythonOlder,
  toml,
}:

buildPythonPackage rec {
  pname = "pylint-plugin-utils";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-plugin-utils";
    tag = version;
    hash = "sha256-8C6vJDu60uSb6G0kvwiO0RAY9dU0yf955mAJAKhIkaQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pylint
    toml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylint_plugin_utils" ];

  meta = with lib; {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = "https://github.com/PyCQA/pylint-plugin-utils";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
