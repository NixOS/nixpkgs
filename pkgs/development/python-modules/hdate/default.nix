{
  lib,
  astral,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pythonRelaxDepsHook,
  pytestCheckHook,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "hdate";
  version = "0.10.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "py-libhdate";
    repo = "py-libhdate";
    rev = "refs/tags/v${version}";
    hash = "sha256-Cni8GegB8GAhtIKKCgSn3QavE/Gi9Rcm9v0grToMyq4=";
  };

  pythonRelaxDeps = [
    "astral"
  ];

  build-system = [
    pdm-backend
    pythonRelaxDepsHook
  ];

  dependencies = [
    astral
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "hdate" ];

  meta = with lib; {
    description = "Python module for Jewish/Hebrew date and Zmanim";
    homepage = "https://github.com/py-libhdate/py-libhdate";
    changelog = "https://github.com/py-libhdate/py-libhdate/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
