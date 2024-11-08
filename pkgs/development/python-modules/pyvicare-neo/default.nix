{
  authlib,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytestCheckHook,
  requests,
  types-requests,
}:

buildPythonPackage rec {
  pname = "pyvicare-neo";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CFenner";
    repo = "PyViCare";
    rev = "refs/tags/v${version}";
    hash = "sha256-QjFrBf58uM5OProKsesyY43MuE1MnIVIVqs5rWUTmes=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    authlib
    requests
    types-requests
  ];

  pythonImportsCheck = [ "PyViCare" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/CFenner/PyViCare/releases/tag/v${version}";
    description = "Library to communicate with the Viessmann ViCare API";
    homepage = "https://github.com/CFenner/PyViCare";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
