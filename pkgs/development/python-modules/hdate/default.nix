{
  lib,
  astral,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pytestCheckHook,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "hdate";
  version = "0.10.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "py-libhdate";
    repo = "py-libhdate";
    rev = "refs/tags/v${version}";
    hash = "sha256-HmdXTvtNiIE2XPFhqs7WpcceEQU7F7RsLFp6/+63yDw=";
  };

  pythonRelaxDeps = [
    "astral"
  ];

  build-system = [
    pdm-backend
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
