{ lib
, buildPythonPackage
, fetchFromGitHub
, pylint
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "pylint-plugin-utils";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    hash = "sha256-uDsSSUWdlzuQz6umoYLbIotOYNEnLQu041ZZVMRd2ww=";
  };

  propagatedBuildInputs = [
    pylint
    toml
  ];

  checkInputs = [
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
