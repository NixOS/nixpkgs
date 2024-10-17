{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crcelk";
  version = "1.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "zeroSteiner";
    repo = "crcelk";
    rev = "refs/tags/v${version}";
    hash = "sha256-eJt0qcG0ejTQJyjOSi6Au2jH801KOMnk7f6cLbd7ADw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "crcelk" ];

  meta = {
    description = "A pure Python implementation of the CRC algorithm";
    homepage = "https://github.com/zeroSteiner/crcelk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
