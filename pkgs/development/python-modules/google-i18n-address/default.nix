{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, requests
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-i18n-address";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "google-i18n-address";
    rev = "refs/tags/${version}";
    hash = "sha256-eh0NcGJfIjCmgTyfSOlDNLrCvMnZKzkJkQb3txVmFAo=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "i18naddress"
  ];

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    homepage = "https://github.com/mirumee/google-i18n-address";
    changelog = "https://github.com/mirumee/google-i18n-address/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
