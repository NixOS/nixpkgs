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
  version = "3.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gocardless";
    repo = "gocardless-pro-python";
    tag = "v${version}";
    hash = "sha256-HnzQMjVOlF9tWuRDrVdle/jD3jlPAbKXA/oNZ70Ew14=";
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
