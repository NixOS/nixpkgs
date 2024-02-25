{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pythonOlder
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "resend";
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "resend";
    repo = "resend-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-3wX2xNz/6Erv97TlQCuF0Sha0fbJJX1LK9dx8xYG4M0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "resend"
  ];

  meta = with lib; {
    description = "SDK for Resend";
    homepage = "https://github.com/resend/resend-python";
    changelog = "https://github.com/resend/resend-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
