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
  version = "3.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gocardless";
    repo = "gocardless-pro-python";
    tag = "v${version}";
    hash = "sha256-GkGNTT+Rw23nR8tiT1lLUzpZKGQE7OBAcv5fyC5Q4fY=";
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

  meta = {
    description = "Client library for the GoCardless Pro API";
    homepage = "https://github.com/gocardless/gocardless-pro-python";
    changelog = "https://github.com/gocardless/gocardless-pro-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
