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
  version = "0.16.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "malwarefrank";
    repo = "dnfile";
    tag = "v${version}";
    hash = "sha256-xizjWY+ByGDOI7HyzT5U4vqmPT2woU7z/3eV0KXDb8Y=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [ pefile ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dnfile" ];

  meta = with lib; {
    description = "Module to parse .NET executable files";
    homepage = "https://github.com/malwarefrank/dnfile";
    changelog = "https://github.com/malwarefrank/dnfile/blob/v${version}/HISTORY.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
