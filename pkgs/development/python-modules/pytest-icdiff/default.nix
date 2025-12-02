{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  icdiff,
  pprintpp,
  pytest,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage {
  pname = "pytest-icdiff";
  version = "0.5-unstable-2024-09-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hjwp";
    repo = "pytest-icdiff";
    rev = "6e2fb8de35e37428a9f7a268c8abb57e9ee285e5";
    hash = "sha256-kSeGz5IExldgi955XOEkQnc8uqxkbyvuDOdz9y3AFIY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytest
    icdiff
    pprintpp
  ];

  # These are failing on the main branch; disable for now
  disabledTests = [
    "test_long_dict"
    "test_mutliline_strings_have_no_escaped_newlines"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pytest_icdiff" ];

  meta = {
    description = "Better error messages in pytest assertions using icdiff";
    homepage = "https://github.com/hjwp/pytest-icdiff";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
