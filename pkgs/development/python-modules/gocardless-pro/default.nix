{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  six,
  setuptools,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "gocardless-pro";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gocardless";
    repo = "gocardless-pro-python";
    tag = "v${version}";
    hash = "sha256-QWiRZ14Y24WDZ6+ljdyQhCaPgYrC6nSyQwr2tIGTTfw=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    requests
    six
  ];

  pythonImportsCheck = [ "gocardless_pro" ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  meta = with lib; {
    description = "Client library for the GoCardless Pro API";
    homepage = "https://github.com/gocardless/gocardless-pro-python";
    changelog = "https://github.com/gocardless/gocardless-pro-python/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
