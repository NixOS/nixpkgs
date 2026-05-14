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
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sh0oki";
    repo = "israel-rail-api";
    tag = "v${version}";
    hash = "sha256-kcux4IBA3FoNnsqNGHsEta9OAkvjYB40234VlidrNzM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytz
    requests
  ];

  pythonImportsCheck = [ "israelrailapi" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/sh0oki/israel-rail-api/releases/tag/${src.tag}";
    description = "Python wrapping of the Israeli Rail API";
    homepage = "https://github.com/sh0oki/israel-rail-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
