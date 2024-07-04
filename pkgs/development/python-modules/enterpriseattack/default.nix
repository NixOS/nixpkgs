{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
  ujson,
}:

buildPythonPackage rec {
  pname = "enterpriseattack";
  version = "0.1.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "xakepnz";
    repo = "enterpriseattack";
    rev = "refs/tags/v.${version}";
    hash = "sha256-cxbGc9iQe94Th6MSUldI17oVCclFhUM78h1w+6KXzm4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    ujson
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "enterpriseattack" ];

  meta = with lib; {
    description = "Module to interact with the Mitre Att&ck Enterprise dataset";
    homepage = "https://github.com/xakepnz/enterpriseattack";
    changelog = "https://github.com/xakepnz/enterpriseattack/releases/tag/v.${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
