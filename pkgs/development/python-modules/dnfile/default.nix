{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pefile,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dnfile";
  version = "0.17.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "malwarefrank";
    repo = "dnfile";
    tag = "v${version}";
    hash = "sha256-JiJ7qvBP0SDGMynQuu2AyCwHU9aDI7Pq5/Z9IiWPWng=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [ pefile ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dnfile" ];

  meta = with lib; {
    description = "Module to parse .NET executable files";
    homepage = "https://github.com/malwarefrank/dnfile";
    changelog = "https://github.com/malwarefrank/dnfile/blob/${src.tag}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
