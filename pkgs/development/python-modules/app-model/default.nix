{ lib
, buildPythonPackage
, fetchFromGitHub
, in-n-out
, psygnal
, pydantic
, pytestCheckHook
, pythonOlder
, typing-extensions
, hatch-vcs
, hatchling
}:

buildPythonPackage rec {
  pname = "app-model";
  version = "0.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GvMPWIvDydJ8C7wDR5DjmEGhVt0jd5e4WzP10a7mGm8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    psygnal
    pydantic
    in-n-out
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "app_model"
  ];

  meta = with lib; {
    description = "Module to implement generic application schema";
    homepage = "https://github.com/pyapp-kit/app-model";
    changelog = "https://github.com/pyapp-kit/app-model/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
