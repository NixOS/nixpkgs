{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "bitstruct";
    tag = version;
    hash = "sha256-4pfRmgi2KYnrKFGyMJc4bV7FwjFn7KVJ36lYm3XOAIk=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "bitstruct" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python bit pack/unpack package";
    homepage = "https://github.com/eerimoq/bitstruct";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
}
