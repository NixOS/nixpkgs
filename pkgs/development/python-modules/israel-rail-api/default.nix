{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  pytz,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "israel-rail-api";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sh0oki";
    repo = "israel-rail-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-OiWK3gi7dQ7SF4fvusKtSFzdhrsvePlscX0EYQ/hlYk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytz
    requests
  ];

  pythonImportsCheck = [ "israelrailapi" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/sh0oki/israel-rail-api/releases/tag/v${version}";
    description = "Python wrapping of the Israeli Rail API";
    homepage = "https://github.com/sh0oki/israel-rail-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
