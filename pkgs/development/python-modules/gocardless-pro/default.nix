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
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gocardless";
    repo = "gocardless-pro-python";
    tag = "v${version}";
    hash = "sha256-NbUgntDZnre6raLGhC2NIY1DctaYInSk5JvsTRDO/dQ=";
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
