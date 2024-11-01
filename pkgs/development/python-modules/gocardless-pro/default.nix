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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gocardless";
    repo = "gocardless-pro-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-RHvGrBIDtjnLax2x7FPu0S5vizUW7dQMaQsyGPXqEh4=";
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
    changelog = "https://github.com/gocardless/gocardless-pro-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
