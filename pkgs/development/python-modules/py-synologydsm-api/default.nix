{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, requests
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "1.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "synologydsm-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-9bh7uLt9+uda6yFCWV6xUh//jFC4DgiS+KtRXQrU3A8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "synology_dsm"
  ];

  meta = with lib; {
    description = "Python API for Synology DSM";
    homepage = "https://github.com/hacf-fr/synologydsm-api";
    changelog = "https://github.com/hacf-fr/synologydsm-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
